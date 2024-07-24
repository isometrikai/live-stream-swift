//
//  ScheduleStreamPopupViewController.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 08/12/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

@available(iOS 15, *)
class ScheduleStreamPopupViewController: UIViewController, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var scheduleForCallback: ((Date) -> Void)?
    var selectedDate: Date? {
        didSet {
            if selectedDate == nil {
                self.datePicker.date = getBufferTime()
                formatDateToString(getBufferTime())
            } else {
                guard let selectedDate else { return }
                self.datePicker.date = selectedDate
                formatDateToString(selectedDate)
            }
        }
    }
    
    lazy var navHeaderView: CustomHeaderView = {
        let view = CustomHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.headerTitle.font = appearance.font.getFont(forTypo: .h3)
        view.headerTitle.textColor = .black
        
        view.headerTitle.text = "Schedule Stream".localized
        view.headerTitle.textAlignment = .left
        view.dividerView.isHidden = false
        
        view.trailingActionButton.isHidden = false
        view.trailingActionButton.setImage(appearance.images.close, for: .normal)
        view.trailingActionButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        view.backgroundColor = .white
        
        return view
    }()
    
    // Date preview view
    
    let datePreviewView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var dateTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .black
        label.font = appearance.font.getFont(forTypo: .h4)
        label.textAlignment = .center
        return label
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        return view
    }()
    
    //:
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .wheels
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return picker
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Confirm".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h4)
        button.layer.cornerRadius = 25
        button.ismTapFeedBack()
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        //datePicker.minimumDate = getBufferTime()
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.addSubview(navHeaderView)
        
        view.addSubview(datePreviewView)
        datePreviewView.addSubview(dateTextLabel)
        datePreviewView.addSubview(dividerView)
        
        view.addSubview(datePicker)
        view.addSubview(confirmButton)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            
            navHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navHeaderView.heightAnchor.constraint(equalToConstant: 60),
            navHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            datePreviewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePreviewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            datePreviewView.heightAnchor.constraint(equalToConstant: 50),
            datePreviewView.topAnchor.constraint(equalTo: navHeaderView.bottomAnchor),
            
            dateTextLabel.centerXAnchor.constraint(equalTo: datePreviewView.centerXAnchor),
            dateTextLabel.centerYAnchor.constraint(equalTo: datePreviewView.centerYAnchor),
            
            dividerView.leadingAnchor.constraint(equalTo: datePreviewView.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: datePreviewView.trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1.5),
            dividerView.bottomAnchor.constraint(equalTo: datePreviewView.bottomAnchor),
            
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: confirmButton.topAnchor),
            datePicker.topAnchor.constraint(equalTo: datePreviewView.bottomAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            confirmButton.heightAnchor.constraint(equalToConstant: 50),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func formatDateToString(_ date: Date){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM YYYY, h:mm a"
        let dateString =  dateFormatter.string(from: date)
        dateTextLabel.text = "\(dateString)"
    }
    
    func getBufferTime() -> Date {
        // setting restriction of 30 minutes as a buffer for scheduling a stream
        let calendar = Calendar(identifier: .indian)
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar

        components.minute = 30
        let minDate = calendar.date(byAdding: components, to: currentDate)!
        
        return minDate
    }
    
    // MARK: - ACTIONS
    
    @objc func closeButtonTapped(){
        self.dismiss(animated: true)
    }
    
    @objc func dateChanged(){
        let date = datePicker.date
        selectedDate = date
        formatDateToString(date)
    }
    
    @objc func confirmButtonTapped(){
        self.dismiss(animated: true)
        scheduleForCallback?(selectedDate ?? getBufferTime())
    }
    
}
