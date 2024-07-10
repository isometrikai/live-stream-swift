//
//  RTMPOptionsContainerView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 07/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

class RTMPOptionsContainerView: UIView, AppearanceProvider {

    // MARK: - PROPERTIES
    
    var delegate: LiveOptionsActionDelegate?
    var addProductViewHeightConstraint: NSLayoutConstraint?
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        return scrollView
    }()
    
    let contentContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileView: GoLiveProfileView = {
        let view = GoLiveProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let toggleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.axis = .vertical
        return stackView
    }()
    
    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = 15
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var hdBroadCastToggle: GoLiveCustomToggleView = {
        let view = GoLiveCustomToggleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isSelected = false
        view.toggleTitleLabel.text = "HD Broadcast".localized
        view.actionButton.tag = 1
        view.actionButton.addTarget(self, action: #selector(toggleOptionTapped(_:)), for: .touchUpInside)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var recordBroadCastToggle: GoLiveCustomToggleView = {
        let view = GoLiveCustomToggleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isSelected = false
        view.toggleTitleLabel.text = "Record Broadcast".localized
        view.actionButton.tag = 2
        view.actionButton.addTarget(self, action: #selector(toggleOptionTapped(_:)), for: .touchUpInside)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var restreamBroadCastToggle: GoLiveCustomToggleView = {
        let view = GoLiveCustomToggleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isSelected = false
        view.toggleTitleLabel.text = "Restream Broadcast".localized
        view.actionButton.tag = 4
        view.actionButton.addTarget(self, action: #selector(toggleOptionTapped(_:)), for: .touchUpInside)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var rtmpStreamKeyToggle: GoLiveCustomToggleView = {
        let view = GoLiveCustomToggleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isSelected = false
        view.toggleTitleLabel.text = "Use Persistent RTMP Stream Key".localized
        view.actionButton.tag = 3
        view.actionButton.addTarget(self, action: #selector(toggleOptionTapped(_:)), for: .touchUpInside)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    // - Add Product view
    
    lazy var addProductView: GoLiveAddProductsView = {
        let view  = GoLiveAddProductsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //:
    
    let rtmpURLView: FormTextWithTitleView = {
        let view = FormTextWithTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.formTitleLabel.text = "RTMP URL".localized
        view.formTextView.customTextLabel.text = "rtmp://rtmp.isometrik.io"
        view.formTextView.customTextLabel.textColor = .white
        view.formTextView.copyButton.isHidden = false
        return view
    }()
    
    let streamKeyView: FormTextWithTitleView = {
        let view = FormTextWithTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.formTitleLabel.text = "Stream Key".localized
        view.formTextView.customTextLabel.text = "Key will be generated after you start a new stream".localized
        return view
    }()
    
    let infoLabelView: FormSimpleTextView = {
        let view = FormSimpleTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.formLabel.text = "Please copy paste the STREAM KEY and the STREAM URL  into your RTMP streaming device".localized + "."
        return view
    }()
    
    let helpLabelView: FormSimpleTextView = {
        let view = FormSimpleTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.formLabel.text = "If you want to create a new STREAM KEY in case you think your key is compromised Click here".localized + "."
        view.formLabel.highlight(searchedText: "Click here".localized, color: .white)
        return view
    }()
    
    // Restream option
    
    let restreamOption: RestreamOptionView = {
        let view = RestreamOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    //:
    
    // Schedule Option
    
    lazy var scheduleToggle: GoLiveCustomToggleView = {
        let view = GoLiveCustomToggleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isSelected = false
        view.toggleTitleLabel.text = "Schedule Live".localized
        view.actionButton.tag = 5
        view.actionButton.addTarget(self, action: #selector(toggleOptionTapped(_:)), for: .touchUpInside)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var dateTimeSelectorView: FormTextWithTitleView = {
        let view = FormTextWithTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.formTextView.outerView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        view.formTextView.outerView.layer.borderWidth = 1
        view.formTitleLabel.text = "Date & time".localized + "*"
        view.formTextView.customTextLabel.text = "Choose Date and Time".localized
        view.formTextView.customTextLabel.textColor = .white
        view.formTextView.copyButton.isHidden = false
        view.formTextView.copyButton.setImage(appearance.images.calendar.withRenderingMode(.alwaysTemplate), for: .normal)
        view.formTextView.copyButton.tintColor = .white
        view.formTextView.tapActionButton.isHidden = false
        view.formTextView.tapActionButton.addTarget(self, action: #selector(dateTimeSelectorTapped), for: .touchUpInside)
        view.isHidden = true
        return view
    }()
    
    //:
    
    // MARK: - MAIN
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        
        scrollView.delaysContentTouches = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        addSubview(scrollView)
        scrollView.addSubview(profileView)
        scrollView.addSubview(toggleStackView)

        // toggle stack view
        toggleStackView.addArrangedSubview(hdBroadCastToggle)
        toggleStackView.addArrangedSubview(recordBroadCastToggle)
        //:
        
        scrollView.addSubview(contentStackView)
    }
    
    func setupConstraints(){
        
        scrollView.ism_pin(to: self)
        NSLayoutConstraint.activate([
            
            profileView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            profileView.heightAnchor.constraint(equalToConstant: 160),
            
            toggleStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            toggleStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            toggleStackView.bottomAnchor.constraint(equalTo: contentStackView.topAnchor, constant: -10),
            toggleStackView.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 5),

            toggleStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            hdBroadCastToggle.heightAnchor.constraint(equalToConstant: 40),
            recordBroadCastToggle.heightAnchor.constraint(equalToConstant: 40),
            rtmpStreamKeyToggle.heightAnchor.constraint(equalToConstant: 40),
            restreamBroadCastToggle.heightAnchor.constraint(equalToConstant: 40),
            
            rtmpURLView.heightAnchor.constraint(equalToConstant: 80),
            streamKeyView.heightAnchor.constraint(equalToConstant: 80),
            
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -30),
            contentStackView.topAnchor.constraint(equalTo: toggleStackView.bottomAnchor),
            
            restreamOption.heightAnchor.constraint(equalToConstant: 50),
            scheduleToggle.heightAnchor.constraint(equalToConstant: 40),
            
            dateTimeSelectorView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        addProductViewHeightConstraint = addProductView.heightAnchor.constraint(equalToConstant: 170) // 270
        addProductViewHeightConstraint?.isActive = true
        
    }
    
    func animateToggles(withStreamOption: StreamOptionToggle, isSelected: Bool) {
        
        switch withStreamOption {
        case .hdBroadCast:
            hdBroadCastToggle.isSelected = isSelected
            break
        case .recordBroadCast:
            recordBroadCastToggle.isSelected = isSelected
            break
        case .persistentRTMPKey:
            rtmpStreamKeyToggle.isSelected = isSelected
            break
        case .restreamBroadcast:
            restreamBroadCastToggle.isSelected = isSelected
            break
        case .scheduleStream:
            scheduleToggle.isSelected = isSelected
            break
        }
        
    }
    
    // MARK: - ACTIONS
    
    @objc func toggleOptionTapped(_ sender: UIButton) {
        
        let streamOption = StreamOptionToggle(rawValue: sender.tag) ?? .hdBroadCast
        delegate?.didToggleOptionTapped(withStreamOption: streamOption)
        
    }
    
    @objc func dateTimeSelectorTapped(){
        delegate?.didDateTimeSelectorTapped()
    }

}
