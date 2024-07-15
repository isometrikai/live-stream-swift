//
//  ScheduleStreamView.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 13/12/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import Foundation
import IsometrikStream

class ScheduleStreamView: UIView, ISMStreamUIAppearanceProvider {

    // MARK: - PROPERTIES
    
    var isometrik: IsometrikSDK?
    var streamData: ISMStream? {
        didSet {
            manageData()
        }
    }
    
    var timer: Timer?
    var scheduleEventDate: Date?
    
    let thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let backCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.8)
        return view
    }()
    
    lazy var closeActionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.close.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        return button
    }()
    
    // Content stack view
    
    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    /// profile view
    
    let profileView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var defaultProfileView: CustomDefaultProfileView = {
        let view = CustomDefaultProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 40
        view.initialsText.font = appearance.font.getFont(forTypo: .h3)
        return view
    }()
    
    ///:
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = appearance.font.getFont(forTypo: .h3)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    lazy var goLiveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Go Live".localized, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h6)
        button.backgroundColor = .white
        button.layer.cornerRadius = 22.5
        button.ismTapFeedBack()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        button.isHidden = true
        return button
    }()
    
    // MARK: - MAIN
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        addSubview(thumbImageView)
        addSubview(backCoverView)
        addSubview(closeActionButton)
        
        addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(profileView)
        profileView.addSubview(defaultProfileView)
        profileView.addSubview(profileImageView)
        
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(timeLabel)
        addSubview(goLiveButton)
    }
    
    func setupConstraints() {
        thumbImageView.ism_pin(to: self)
        backCoverView.ism_pin(to: self)
        NSLayoutConstraint.activate([
            closeActionButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeActionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            closeActionButton.heightAnchor.constraint(equalToConstant: 40),
            closeActionButton.widthAnchor.constraint(equalToConstant: 40),
            
            contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            profileView.heightAnchor.constraint(equalToConstant: 80),
            //profileView.widthAnchor.constraint(equalToConstant: 80)
            
            profileImageView.centerYAnchor.constraint(equalTo: profileView.centerYAnchor),
            profileImageView.centerXAnchor.constraint(equalTo: profileView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            
            defaultProfileView.centerYAnchor.constraint(equalTo: profileView.centerYAnchor),
            defaultProfileView.centerXAnchor.constraint(equalTo: profileView.centerXAnchor),
            defaultProfileView.widthAnchor.constraint(equalToConstant: 80),
            defaultProfileView.heightAnchor.constraint(equalToConstant: 80),
            
            goLiveButton.heightAnchor.constraint(equalToConstant: 45),
            goLiveButton.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 20),
            goLiveButton.centerXAnchor.constraint(equalTo: centerXAnchor)
            
        ])
    }
    
    func manageData(){
        
        guard let data = streamData, let isometrik else { return }
        
        let firstName = data.userDetails?.firstName ?? "U"
        let lastName = data.userDetails?.lastName ?? "n"
        let scheduleStartTime = data.scheduleStartTime ?? 0
        let scheduleStartDate = Date(timeIntervalSince1970: Double(scheduleStartTime))
        let currentUserId = isometrik.getUserSession().getUserId()
        
        // Get current date
        let userCalendar = Calendar.current
        let date = Date()
        let components = userCalendar.dateComponents([.hour, .minute, .month, .year, .day, .second], from: date)
        let currentDate = userCalendar.date(from: components)!
        
        // Set EventDate
        self.scheduleEventDate = scheduleStartDate
        
        if let streamImageURlString = data.streamImage {
            if let url = URL(string: streamImageURlString) {
                thumbImageView.kf.setImage(with: url)
            }
        }
        
        if let profileUrlString = data.userDetails?.profilePic {
            if profileUrlString != UserDefaultsProvider.shared.getIsometrikDefaultProfile() {
                if let profileURL = URL(string: profileUrlString) {
                    profileImageView.kf.setImage(with: profileURL)
                }
            } else {
                profileImageView.image = UIImage()
            }
        }
        
        defaultProfileView.initialsText.text = "\(firstName.prefix(1))\(lastName.prefix(1))".uppercased()
        
        if data.userDetails?.isomatricChatUserId == currentUserId {
            // condition satisfied means, this is my scheduled stream
            goLiveButton.isHidden = false
            titleLabel.text = "You can go live in".localized
            
            // Enable the goLive 5 minutes before starting time
            let difference = Date().minuteDifferenceBetween(scheduleStartDate)
            
            if difference < 5 {
                goLiveButton.isEnabled = true
                goLiveButton.alpha = 1
            } else {
                goLiveButton.isEnabled = false
                goLiveButton.alpha = 0.3
            }
            
            if currentDate < scheduleStartDate {
                self.startCountdownTimer()
            } else {
                titleLabel.text = "You can go live now".localized
            }
            
            
        } else {
            // condition satisfied means, this not my scheduled stream
            titleLabel.text = "Will be live in".localized + ".."
            goLiveButton.isHidden = true
            
            if currentDate < scheduleStartDate {
                self.startCountdownTimer()
            } else {
                titleLabel.text = "Waiting for host to go live".localized + "."
            }
        }
        
    }

}
