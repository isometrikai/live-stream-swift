//
//  PKRecieveInvitationViewController.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 20/06/24.
//

import UIKit
import Kingfisher
import IsometrikStream

class PKRecieveInvitationViewController: UIViewController, ISMStreamUIAppearanceProvider {

    // MARK: - PROPERTIES
    
    var viewModel: PKRecievedInvitationViewModel
    
    let profileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    let profileDefaultStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    lazy var linkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = appearance.images.linking
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h4)
        label.textAlignment = .center
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = appearance.colors.appLightGray
        label.font = appearance.font.getFont(forTypo: .h8)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Custom Progess loader
    
    let customLoader: PKCustomLoaderView = {
        let view = PKCustomLoaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Bottom actions stack
    
    let bottomActionStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var rejectButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reject", for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h6)
        button.backgroundColor = .clear
        button.setTitleColor(appearance.colors.appLightGray, for: .normal)
        button.layer.borderColor = appearance.colors.appLightGray.withAlphaComponent(0.7).cgColor
        button.layer.borderWidth = 1
        button.ismTapFeedBack()
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(rejectButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var acceptButton: UIButton = {
        let button = UIButton()
        button.setTitle("Accept", for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h6)
        button.backgroundColor = appearance.colors.appColor
        button.setTitleColor(.white, for: .normal)
        button.ismTapFeedBack()
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - INITIALIZER
    
    init(viewModel: PKRecievedInvitationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupProfileView()
        
        viewModel.actionDelegate = self
        viewModel.setLinkingState(.request)
    }
    
    // MARK: - FUNTIONS
    
    func setupViews(){
        view.backgroundColor = appearance.colors.appDarkGray
        view.addSubview(profileDefaultStack)
        view.addSubview(profileStackView)
        view.addSubview(linkImage)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        
        view.addSubview(bottomActionStack)
        bottomActionStack.addArrangedSubview(rejectButton)
        bottomActionStack.addArrangedSubview(acceptButton)
        
        view.addSubview(customLoader)
    }
    
    func setupConstraints(){
        
        NSLayoutConstraint.activate([
            profileStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            profileStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileStackView.heightAnchor.constraint(equalToConstant: 100),
            
            profileDefaultStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            profileDefaultStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileDefaultStack.heightAnchor.constraint(equalToConstant: 100),
            
            linkImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 65),
            linkImage.widthAnchor.constraint(equalToConstant: 50),
            linkImage.heightAnchor.constraint(equalToConstant: 50),
            linkImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: profileStackView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            bottomActionStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomActionStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bottomActionStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            bottomActionStack.heightAnchor.constraint(equalToConstant: 50),
            
            customLoader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customLoader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            customLoader.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            customLoader.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    func createUserProfile(image: String, isURL: Bool) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if isURL {
            if image != UserDefaultsProvider.shared.getIsometrikDefaultProfile() {
                if let url = URL(string: image) {
                    imageView.kf.setImage(with: url)
                }
            }
        }
        imageView.layer.borderColor = appearance.colors.appLightGray.withAlphaComponent(0.5).cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        return imageView
    }
    
    func createDefaultView(text: String) -> CustomDefaultProfileView {
        let defaultView = CustomDefaultProfileView()
        defaultView.translatesAutoresizingMaskIntoConstraints = false
        
        let initials = text.prefix(2).uppercased()
        defaultView.initialsText.text = initials
        
        defaultView.layer.borderColor = appearance.colors.appLightGray.withAlphaComponent(0.5).cgColor
        defaultView.layer.borderWidth = 1
        defaultView.layer.cornerRadius = 50
        defaultView.clipsToBounds = true
        return defaultView
    }
    
    func setupProfileView(){
        
        /// removing all subviews first
        profileDefaultStack.ism_removeFullyAllArrangedSubviews()
        profileStackView.ism_removeFullyAllArrangedSubviews()
        
        let profile1 = self.viewModel.streamInfo.userDetails?.userProfile ?? ""
        let profile2 = self.viewModel.isometrik.getUserSession().getUserImage()
        
        let userName1 = self.viewModel.streamInfo.userDetails?.userName ?? ""
        let userName2 = self.viewModel.isometrik.getUserSession().getUserName()
        
        let userNameArray = [userName1 , userName2]
        
        let imageArr = [profile1,  profile2]
        
        for i in 0..<imageArr.count {
            
            let profile = createUserProfile(image: imageArr[i], isURL: true)
            profileStackView.addArrangedSubview(profile)
            
            let defaultView = createDefaultView(text: userNameArray[i])
            profileDefaultStack.addArrangedSubview(defaultView)
            
            NSLayoutConstraint.activate([
                profile.heightAnchor.constraint(equalToConstant: 100),
                profile.widthAnchor.constraint(equalToConstant: 100),
                
                defaultView.heightAnchor.constraint(equalToConstant: 100),
                defaultView.widthAnchor.constraint(equalToConstant: 100)
            ])
        }
        
    }
    
    func callForAction(action: PKInvitationResponse){
        
        self.dismiss(animated: true)
        
        let inviteId = viewModel.inviteId
        let streamId = viewModel.streamInfo.streamId ?? ""
        
        // reseting local variables
        viewModel.resetToDefault()
        
        viewModel.isometrik.getIsometrik().updateInvitationResponse(inviteId: inviteId, streamId: streamId, response: action) { result in
            self.viewModel.response_callBack?(action, result.streamData)
        } failure: { error in
            
            self.viewModel.response_callBack?(action,nil)
            
            switch error{
            case .noResultsFound(_):
                break
            case .invalidResponse:
                DispatchQueue.main.async {
                    self.view.showToast( message: "PK Invite: Invalid Response")
                }
            case .httpError(let errorCode, let errorMessage):
                DispatchQueue.main.async{
                    self.view.showToast( message: "PK Invite: \(errorCode) \(errorMessage?.error ?? "")")
                }
            default :
                break
            }
        }
        
    }
    
    // MARK: - ACTIONS

    // call api to reject invitation
    @objc func rejectButtonTapped(){
        callForAction(action: .reject)
    }
    
    // call api to accept invitation
    @objc func acceptButtonTapped(){
        callForAction(action: .accept)
    }
    
    @objc func rejectTimerAction(){
        self.viewModel.maximumRejectWait -= 1
        if self.viewModel.maximumRejectWait == 1 {
            self.viewModel.rejectTimer?.invalidate()
            self.viewModel.maximumRejectWait = 15
            rejectButtonTapped()
        }
        let remainingTime = Int(self.viewModel.maximumRejectWait)
        self.rejectButton.setTitle("Reject in (\(remainingTime)s)", for: .normal)
    }
    
}


