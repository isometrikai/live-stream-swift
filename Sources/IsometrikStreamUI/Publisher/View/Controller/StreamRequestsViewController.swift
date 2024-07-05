//
//  StreamRequestsViewController.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 05/05/22.
//

import UIKit
import Kingfisher
import IsometrikStream

class StreamRequestsViewController: UIViewController, AppearanceProvider {

    // MARK: - PROPERTIES
    
    var viewModel: PublisherViewModel
    
    let userImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = -20
        stackView.axis = .horizontal
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h5)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h8)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // option stack view
    
    let actionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h6)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 30
        button.ismTapFeedBack()
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h6)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 30
        button.backgroundColor = appearance.colors.appRed
        button.ismTapFeedBack()
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = appearance.colors.appDarkGray
        setupViews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupUI()
    }
    
    init(viewModel: PublisherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNCTIONS
    
    func setupUI(){
        
        if let publisherStatus = viewModel.publisherStatus {
            if publisherStatus.accepted.unwrap {
                self.viewModel.requestingType = .accepting
            } else {
                self.viewModel.requestingType = publisherStatus.pending.unwrap ? .accepting : .sending
            }
        } else {
            self.viewModel.requestingType = .sending
        }
        
        
        // removing previous views first before adding
        userImageStackView.subviews.forEach({ $0.removeFromSuperview() })
        
        let isometrik = viewModel.isometrik
        let streamInfo = viewModel.streamData
        
        let firstName = streamInfo.userDetails?.userName ?? ""
        let myName = isometrik.getUserSession().getUserName()
        let initials = [ "\(firstName.prefix(2))", "\(myName.prefix(2))"]
        
        switch viewModel.requestingType {
        case .sending:
            
            actionStackView.ism_removeFullyAllArrangedSubviews()
            actionStackView.addArrangedSubview(actionButton)
            
            viewModel.stackViewHeightConstraint?.constant = 85
            viewModel.stackViewWidthConstraint?.constant = 150
            
            for i in 0..<viewModel.imagesArr.count {
                let imageView = createImageView(with: viewModel.imagesArr[i], initials: initials[i])
                imageView.imageView.layer.cornerRadius = 42.5
                imageView.defaultImageView.layer.cornerRadius = 42.5
                imageView.clipsToBounds = true
                userImageStackView.addArrangedSubview(imageView)
            }
            titleLabel.text = "Request to be a co-publisher in the live video"
            subtitleLabel.text = "Once you join a live video as a co-publisher, anybody canwatch and some of your followers may get notified"

            actionButton.setTitle("Send Request", for: .normal)
            actionButton.backgroundColor = appearance.colors.appColor
            actionButton.setTitleColor(.black, for: .normal)
            
            break
            
        case .accepting:
            
            guard let publisherStatus = viewModel.publisherStatus else { return }
            
            viewModel.stackViewHeightConstraint?.constant = 100
            viewModel.stackViewWidthConstraint?.constant = 100
            if viewModel.imagesArr.count > 0 {
                let imageView = createImageView(with: viewModel.imagesArr[0], initials: initials[0])
                imageView.imageView.layer.cornerRadius = 50
                imageView.defaultImageView.layer.cornerRadius = 50
                userImageStackView.addArrangedSubview(imageView)
            }
            
            /// check for existence in member list
            let currentUserId = isometrik.getUserSession().getUserId()
            let existInMemberList = existenceInMemberList(memberId: currentUserId)
            let isAccepted = viewModel.publisherStatus?.accepted ?? false
            let isPending = viewModel.publisherStatus?.pending ?? false

            if isAccepted && existInMemberList {
                
                actionStackView.ism_removeFullyAllArrangedSubviews()
                actionStackView.addArrangedSubview(actionButton)
                
                titleLabel.text = "\(streamInfo.userDetails?.firstName ?? "") " + " \(streamInfo.userDetails?.lastName ?? "")" + " has accepted your request to join the live video as a co-publisher"
                subtitleLabel.text = "you can now join the live video as a co-publisher and start publishing"
                actionButton.setTitle("Start Video", for: .normal)
                
                actionButton.backgroundColor = appearance.colors.appColor
                actionButton.setTitleColor(.black, for: .normal)
                
            } else if isPending {
                
                actionStackView.ism_removeFullyAllArrangedSubviews()
                actionStackView.addArrangedSubview(deleteButton)
                actionStackView.addArrangedSubview(actionButton)
                
                deleteButton.setTitle("Delete", for: .normal)
                
                titleLabel.text = "Your request to be a co-publisher in the live broadcaster is pending"
                subtitleLabel.text = "You can either continue watching until" + " \(streamInfo.userDetails?.firstName ?? "") " + " \(streamInfo.userDetails?.lastName ?? "") " + "accepts your request or delete request"
                
                actionButton.setTitle("Continue", for: .normal)
                
                actionButton.backgroundColor = .white
                actionButton.setTitleColor(.black, for: .normal)
                
            } else {
                
                // It means denied
                actionStackView.ism_removeFullyAllArrangedSubviews()
                actionStackView.addArrangedSubview(deleteButton)
                actionStackView.addArrangedSubview(actionButton)
                
                deleteButton.setTitle("Exit", for: .normal)
                
                titleLabel.text = "\(streamInfo.userDetails?.firstName ?? "") " + " \(streamInfo.userDetails?.lastName ?? "") " + "previously rejected your request to join the live broadcast as a co-publisher"
                
                subtitleLabel.text = "You can either continue watching or exit from the live stream"
                
                actionButton.setTitle("Continue", for: .normal)
                
                actionButton.backgroundColor = .white
                actionButton.setTitleColor(.black, for: .normal)
                
            }
            break
            
        case .none:
            break
        }
    }
    
    func setupViews(){
        view.addSubview(userImageStackView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        
        view.addSubview(actionStackView)
        actionStackView.addArrangedSubview(actionButton)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            userImageStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userImageStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            titleLabel.topAnchor.constraint(equalTo: userImageStackView.bottomAnchor, constant: 20),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            
            actionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            actionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            actionStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            actionStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        viewModel.stackViewWidthConstraint = userImageStackView.widthAnchor.constraint(equalToConstant: 100)
        viewModel.stackViewWidthConstraint?.isActive = true
        
        viewModel.stackViewHeightConstraint = userImageStackView.heightAnchor.constraint(equalToConstant: 100)
        viewModel.stackViewHeightConstraint?.isActive = true
    }
    
    func createImageView(with url: String = "", initials: String = "") -> customPublishingImageView {
        let customImageView = customPublishingImageView()
        if url != UserDefaultsProvider.shared.getIsometrikDefaultProfile() {
            if let imageUrl = URL(string: url) {
                customImageView.imageView.kf.setImage(with: imageUrl)
            } else {
                customImageView.imageView.image = UIImage()
            }
        } else {
            customImageView.imageView.image = UIImage()
        }
        
        customImageView.defaultImageView.initialsText.font = appearance.font.getFont(forTypo: .h4)
        customImageView.defaultImageView.initialsText.text = initials.uppercased()
        
        return customImageView
    }
    
    func existenceInMemberList(memberId: String) -> Bool {
        
        let streamsData = viewModel.streamData
        
        guard let members = streamsData.members else {
            return false
        }
        
        let isExist = members.filter { member in
            return member.userID == memberId
        }
        
        return isExist.count > 0
        
    }
    
    func getRequestStatus(){
        viewModel.getCopublisherStatus { response in
            switch response {
            case .success:
                self.setupUI()
                self.viewModel.success_callback?(self.viewModel.publisherStatus)
                break
            case .failure(_):
                self.setupUI()
                break
            }
        }
    }
    
    // MARK: - ACTIONS
    
    @objc func actionButtonTapped(){
        
        guard let user = viewModel.user else {
            return
        }
        
        let streamInfo = viewModel.streamData
        let isometrik = viewModel.isometrik
        
        if viewModel.requestingType == .sending {
            
            viewModel.sendCopublishingRequest { response in
                switch response {
                case .success:
                    self.getRequestStatus()
                    break
                case .failure(let msg):
                    self.view.showISMLiveErrorToast(message: msg)
                    break
                }
            }
            
            
        } else if viewModel.requestingType == .accepting {
            
            let isAccepted = viewModel.publisherStatus?.accepted ?? false
            let isPending = viewModel.publisherStatus?.pending ?? false
            
            /// check for existence in member list
            let currentUserId = isometrik.getUserSession().getUserId()
            let existInMemberList = existenceInMemberList(memberId: currentUserId)
            
            if isAccepted && existInMemberList {
                viewModel.delegate?.didStartPublishingVideo()
                dismiss(animated: true)
            } else if isPending {
                dismiss(animated: true)
            } else if !isPending && !isAccepted {
                dismiss(animated: true)
            } else {
                dismiss(animated: true)
            }
            
        }
    }
    
    @objc func deleteButtonTapped(){
        
        guard let user = viewModel.user else {
            return
        }
        
        let streamInfo = viewModel.streamData
        
        if viewModel.requestingType == .accepting {
            
            let isAccepted = viewModel.publisherStatus?.accepted ?? false
            let isPending = viewModel.publisherStatus?.pending ?? false

            if isPending {
                // call for deleting request
                //dismiss(animated: true)
                viewModel.deleteCopublishingRequest { response in
                    switch response {
                    case .success:
                        self.viewModel.requestingType = .sending
                        self.viewModel.publisherStatus = nil
                        self.viewModel.success_callback?(nil)
                        self.setupUI()
                        break
                    case .failure(let msg):
                        self.view.showISMLiveErrorToast(message: msg)
                        break
                    }
                }
                
            } else if !isPending && !isAccepted {
                // leave stream as a viewer
                dismiss(animated: true)
                viewModel.delegate?.didLeaveStream()
            } else {
                // case when user kicked out
                dismiss(animated: true)
                viewModel.delegate?.didLeaveStream()
            }
            
        }
    }
    
}

class customPublishingImageView: UIView {
    
    // MARK: - PROPERTIES
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerCurve = .continuous
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.borderWidth = 1.5
        return imageView
    }()
    
    let defaultImageView: CustomDefaultProfileView = {
        let view = CustomDefaultProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerCurve = .continuous
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1.5
        return view
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
    
    // MARK: - FUNTIONS
    
    func setupViews(){
        addSubview(defaultImageView)
        addSubview(imageView)
    }
    
    func setupConstraints(){
        imageView.ism_pin(to: self)
        defaultImageView.ism_pin(to: self)
    }
    
}
