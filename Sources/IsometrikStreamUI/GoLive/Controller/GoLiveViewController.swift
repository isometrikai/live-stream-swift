//
//  GoLiveViewController.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 06/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import Kingfisher

final public class GoLiveViewController: UIViewController {

    // MARK: - PROPERTIES
    
    public var viewModel: GoLiveViewModel
    
    let cameraView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let blackCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.6)
        return view
    }()
    
    lazy var headerView: GoLiveHeaderView = {
        let view = GoLiveHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    lazy var contentView: GoLiveOptionsContentView = {
        let view = GoLiveOptionsContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.goLiveContentContainerView.profileView.delegate = self
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        return view
    }()
    
    lazy var footerView: GoLiveFooterView = {
        let view = GoLiveFooterView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    let customLoaderView: GoLiveUploaderLoaderView = {
        let view = GoLiveUploaderLoaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    // MARK: - MAIN
    
    public init(viewModel: GoLiveViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigations()
        setupViews()
        setupConstraints()
        createSession()
        setDefaults()
        addObservers()
        setDataForEdit()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        createSession()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLivePreview()
        removeObservers()
    }
    
    // MARK: - FUNCTIONS
    
    func setupNavigations(){
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupViews(){
        view.backgroundColor = .black
        view.addSubview(cameraView)
        view.addSubview(blackCoverView)
        
        view.addSubview(headerView)
        view.addSubview(contentView)
        view.addSubview(footerView)
        view.addSubview(customLoaderView)
        ism_hideKeyboardWhenTappedAround()
    }
    
    func setupConstraints(){
        
        cameraView.ism_pin(to: view)
        blackCoverView.ism_pin(to: view)
        customLoaderView.ism_pin(to: view)
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50), //205
            
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            contentView.bottomAnchor.constraint(equalTo: footerView.bottomActionView.topAnchor),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 160)
        ])
        
    }
    
    func setDefaults(){
        
        let isometrik = viewModel.isometrik
        let isRTMPEnabled = isometrik.getStreamOptionsConfiguration().isRTMPStreamEnabled
        let isRestreamEnabled = isometrik.getStreamOptionsConfiguration().isRestreamEnabled
        
        let footerBottomActionStack = footerView.bottomActionStack
        
        let contentContainerView = contentView.goLiveContentContainerView
        let rtmpUrlView = contentContainerView.rtmpURLView.formTextView
        let streamKeyView = contentContainerView.streamKeyView.formTextView
        let guestLiveButton = footerView.guestLiveButton
        let liveFromDeviceButton = footerView.liveFromDeviceButton
        
        let scrollView = contentContainerView.scrollView
        scrollView.delegate = self
        
        // setting guest live option as default
        viewModel.currenStreamType = .guestLive
        didGoLiveStreamTypeActionTapped(with: .guestLive)
        
        contentView.goLiveContentContainerView.animatePaidStreamsButton(isPremium: false)
        
        if isRTMPEnabled {
            viewModel.getUserDetails { success in
                if !success { return }
                
                rtmpUrlView.customTextLabel.textColor = .white
                rtmpUrlView.customTextLabel.text = self.viewModel.rtmpURL
                
                streamKeyView.copyButton.isHidden = false
                streamKeyView.customTextLabel.textColor = .white
                streamKeyView.customTextLabel.text = self.viewModel.streamKey
            }
            
            footerBottomActionStack.addArrangedSubview(guestLiveButton)
            footerBottomActionStack.addArrangedSubview(liveFromDeviceButton)
        } else {
            footerBottomActionStack.addArrangedSubview(guestLiveButton)
        }

        
    }
    
    func setDataForEdit(){
     
        guard let streamData = viewModel.streamData, viewModel.isEditing else { return }
        
        // MARK: Updating view model -
        
        viewModel.isHdBroadcast = streamData.hdBroadcast.unwrap
        viewModel.recordBroadcast = streamData.isRecorded.unwrap
        
        // toggling original value, so that UI changes will toggle it back
        viewModel.restreamBroadcast = !(streamData.restream.unwrap)
        
        // harcoded updates
        viewModel.isScheduleStream = true
        let scheduleStartTime = TimeInterval(streamData.scheduleStartTime.unwrap)
        viewModel.scheduleFor = Date(timeIntervalSince1970: scheduleStartTime)
        
        // MARK: Updating UI -
        
        let containerView = contentView.goLiveContentContainerView
        let profileView = containerView.profileView
        let addProductView = containerView.addProductView
        
        // stream Image
        if let streamImage = URL(string: streamData.streamImage.unwrap) {
            profileView.profileCoverImageView.kf.setImage(with: streamImage)
        }
        profileView.clearImageButton.isHidden = false
        
        // stream description
        let streamDescription = streamData.streamDescription.unwrap
        profileView.streamTextView.text = streamDescription
        profileView.streamTextView.textColor = .white
        
        // Stream Option: Restream, Recorded, HDBroadcast
        containerView.hdBroadCastToggle.isSelected = viewModel.isHdBroadcast
        containerView.recordBroadCastToggle.isSelected = viewModel.recordBroadcast
        self.didToggleOptionTapped(withStreamOption: .restreamBroadcast)
        
        // Hidden options
        let scheduleOption = contentView.goLiveContentContainerView.scheduleToggle
        let dateTimeSelectorView = containerView.dateTimeSelectorView
        scheduleOption.isHidden = true
        dateTimeSelectorView.isHidden = true
        
        footerView.bottomActionView.isHidden = true
        footerView.goLiveButtonBottomConstraint?.constant = -15
        
        // Go live button changes
        footerView.goLiveButton.setTitle("Update Stream", for: .normal)
        
        // Getting the products
        viewModel.getProducts { success in
            if success {
                containerView.addProductViewHeightConstraint?.constant = 290
                addProductView.addButton.isHidden = false
                //addProductView.productData = self.viewModel.selectedProducts
            }
        }
    }

}
