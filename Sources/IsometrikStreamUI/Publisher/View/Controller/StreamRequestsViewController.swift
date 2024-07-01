//
//  StreamRequestsViewController.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 05/05/22.
//

import UIKit
import Kingfisher
import IsometrikStream

protocol StreamRequestsActionDelegate {
    func didRequestToCoPublisher(user: ISMStreamUser , streamInfo: ISMStream)
    func didStartPublishingVideo(streamInfo: ISMStream)
    func didDeleteRequestTapped(user: ISMStreamUser , streamInfo: ISMStream)
    func didLeaveStream()
}

class StreamRequestsViewController: UIViewController, AppearanceProvider {

    // MARK: - PROPERTIES
    
    var viewModel = PublisherViewModel()
    var delegate: StreamRequestsActionDelegate?
    
    var stackViewHeightConstraint: NSLayoutConstraint?
    var stackViewWidthConstraint: NSLayoutConstraint?
    var imagesArr: [String] = [] {
        didSet {
            // Updating UI
            setupUI()
        }
    }
    
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
        label.text = "Title label".ism_localized
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h5)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Default Subtitle label".ism_localized
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
        button.setTitleColor(.white, for: .normal)
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
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupUI()
    }
    
    init(publisherStatus: ISMPublisher?, isometrik: IsometrikSDK?, streamInfo: ISMStream?, requestingType: RequestingType?, user: ISMStreamUser?) {
        super.init(nibName: nil, bundle: nil)
        viewModel.publisherStatus = publisherStatus
        viewModel.requestingType = requestingType
        viewModel.streamData = streamInfo
        viewModel.isometrik = isometrik
        viewModel.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNCTIONS
    
    func setupUI(){
        // removing previous views first before adding
        userImageStackView.subviews.forEach({ $0.removeFromSuperview() })
        
        guard let isometrik = viewModel.isometrik,
              let streamInfo = viewModel.streamData
        else { return }
        
        let firstName = streamInfo.userDetails?.userName ?? ""
        let myName = isometrik.getUserSession().getUserName() ?? ""
        let initials = [ "\(firstName.prefix(2))", "\(myName.prefix(2))"]
        
        switch viewModel.requestingType {
        case .sending:
            
            actionStackView.ism_removeFullyAllArrangedSubviews()
            actionStackView.addArrangedSubview(actionButton)
            
            stackViewHeightConstraint?.constant = 65
            stackViewWidthConstraint?.constant = 110
            
            for i in 0..<imagesArr.count {
                print("IMAGES NAME : ---- > \(imagesArr[i])")
                let imageView = createImageView(with: imagesArr[i], initials: initials[i])
                imageView.imageView.layer.cornerRadius = 32.5
                imageView.defaultImageView.layer.cornerRadius = 32.5
                imageView.clipsToBounds = true
                userImageStackView.addArrangedSubview(imageView)
            }
            titleLabel.text = "Request to be a co-publisher in the live video".ism_localized
            subtitleLabel.text = "Once you join a live video as a co-publisher, anybody canwatch and some of your followers may get notified".ism_localized
            
            actionButton.setTitle("Send Request", for: .normal)
            break
            
        case .accepting:
            
            guard let publisherStatus = viewModel.publisherStatus else { return }
            
            stackViewHeightConstraint?.constant = 100
            stackViewWidthConstraint?.constant = 100
            if imagesArr.count > 0 {
                let imageView = createImageView(with: imagesArr[0], initials: initials[0])
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
                
                titleLabel.text = "\(streamInfo.userDetails?.firstName ?? "") " + " \(streamInfo.userDetails?.lastName ?? "")" + " has accepted your request to join the live video as a co-publisher".ism_localized
                subtitleLabel.text = "you can now join the live video as a co-publisher and start publishing".ism_localized
                actionButton.setTitle("Start Video".ism_localized, for: .normal)
            } else if isPending {
                
                actionStackView.ism_removeFullyAllArrangedSubviews()
                actionStackView.addArrangedSubview(deleteButton)
                actionStackView.addArrangedSubview(actionButton)
                
                deleteButton.setTitle("Delete", for: .normal)
                
                titleLabel.text = "Your request to be a co-publisher in the live broadcaster is pending".ism_localized
                subtitleLabel.text = "You can either continue watching until".ism_localized + " \(streamInfo.userDetails?.firstName ?? "") " + " \(streamInfo.userDetails?.lastName ?? "") " + "accepts your request or delete request".ism_localized
                
                actionButton.setTitle("Continue".ism_localized, for: .normal)
                
            } else {
                
                // It means denied
                actionStackView.ism_removeFullyAllArrangedSubviews()
                actionStackView.addArrangedSubview(deleteButton)
                actionStackView.addArrangedSubview(actionButton)
                
                deleteButton.setTitle("Exit", for: .normal)
                
                titleLabel.text = "\(streamInfo.userDetails?.firstName ?? "") " + " \(streamInfo.userDetails?.lastName ?? "") " + "previously rejected your request to join the live broadcast as a co-publisher"
                
                subtitleLabel.text = "You can either continue watching or exit from the live stream"
                
                actionButton.setTitle("Continue".ism_localized, for: .normal)
                
            }
            break
            
        case .none:
            break
        }
    }
    
    func setupViews(){
        view.backgroundColor = .black.withAlphaComponent(0.8)
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
        
        stackViewWidthConstraint = userImageStackView.widthAnchor.constraint(equalToConstant: 100)
        stackViewWidthConstraint?.isActive = true
        
        stackViewHeightConstraint = userImageStackView.heightAnchor.constraint(equalToConstant: 100)
        stackViewHeightConstraint?.isActive = true
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
        
        guard let streamsData = viewModel.streamData,
              let members = streamsData.members
        else { return false }
        
        let isExist = members.filter { member in
            return member.userID == memberId
        }
        
        return isExist.count > 0
    }
    
    // MARK: - ACTIONS
    
    @objc func actionButtonTapped(){
        
        guard let user = viewModel.user,
              let streamInfo = viewModel.streamData,
              let isometrik = viewModel.isometrik
        else {
            return
        }
        
        if viewModel.requestingType == .sending {
            delegate?.didRequestToCoPublisher(user: user, streamInfo: streamInfo)
            dismiss(animated: true)
        } else if viewModel.requestingType == .accepting {
            
            let isAccepted = viewModel.publisherStatus?.accepted ?? false
            let isPending = viewModel.publisherStatus?.pending ?? false
            
            /// check for existence in member list
            let currentUserId = isometrik.getUserSession().getUserId()
            let existInMemberList = existenceInMemberList(memberId: currentUserId)
            
            if isAccepted && existInMemberList {
                delegate?.didStartPublishingVideo(streamInfo: streamInfo)
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
        guard let user = viewModel.user , let streamInfo = viewModel.streamData else {
            return
        }
        
        if viewModel.requestingType == .accepting {
            
            let isAccepted = viewModel.publisherStatus?.accepted ?? false
            let isPending = viewModel.publisherStatus?.pending ?? false

            if isPending {
                // call for deleting request
                dismiss(animated: true)
                delegate?.didDeleteRequestTapped(user: user, streamInfo: streamInfo)
            } else if !isPending && !isAccepted {
                // leave stream as a viewer
                dismiss(animated: true)
                delegate?.didLeaveStream()
            } else {
                // case when user kicked out
                dismiss(animated: true)
                delegate?.didLeaveStream()
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
