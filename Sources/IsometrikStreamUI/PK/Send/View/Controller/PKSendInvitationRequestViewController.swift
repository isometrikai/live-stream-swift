//
//  PKSendInvitationRequestViewController.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 20/06/24.
//

import UIKit
import Kingfisher
import IsometrikStream

class PKSendInvitationRequestViewController: UIViewController {

    // MARK: - PROPERTIES
    
    let viewModel: PKSendInvitationViewModel
    
    let profileView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "ism_UserDefault")
        imageView.layer.cornerRadius = 50
        imageView.layer.borderColor = Appearance.default.colors.appLightGray.withAlphaComponent(0.3).cgColor
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let defaultProfileView: CustomDefaultProfileView = {
        let defaultView = CustomDefaultProfileView()
        defaultView.layer.cornerRadius = 50
        defaultView.initialsText.font = Appearance.default.font.getFont(forTypo: .h3)
        return defaultView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.font = Appearance.default.font.getFont(forTypo: .h4)
        label.textAlignment = .center
        label.text = ""
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = Appearance.default.colors.appLightGray
        label.font = Appearance.default.font.getFont(forTypo: .h8)
        label.textAlignment = .center
        label.text = ""
        return label
    }()
    
    // MARK: - Custom Progess loader
    
    let customLoader: PKCustomLoaderView = {
        let view = PKCustomLoaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Close", for: .normal)
        button.titleLabel?.font = Appearance.default.font.getFont(forTypo: .h5)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundColor = Appearance.default.colors.appRed
        button.isHidden = true
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - MAIN
    
    init(viewModel: PKSendInvitationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setUpUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.customLoader.startAnimatingLoader()
        }
    }
    
    // MARK: - FUNTIONS
    
    func setupViews(){
        view.backgroundColor = Appearance.default.colors.appDarkGray
        view.addSubview(defaultProfileView)
        view.addSubview(profileView)
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        
        view.addSubview(customLoader)
        view.addSubview(dismissButton)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            profileView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileView.widthAnchor.constraint(equalToConstant: 100),
            profileView.heightAnchor.constraint(equalToConstant: 100),
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            
            defaultProfileView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            defaultProfileView.widthAnchor.constraint(equalToConstant: 100),
            defaultProfileView.heightAnchor.constraint(equalToConstant: 100),
            defaultProfileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: defaultProfileView.bottomAnchor, constant: 15),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            
            customLoader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customLoader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            customLoader.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            customLoader.heightAnchor.constraint(equalToConstant: 40),
            
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dismissButton.heightAnchor.constraint(equalToConstant: 50),
            dismissButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    func setUpUI(){
        
        self.customLoader.startAnimatingLoader()
        
        let profilePic = viewModel.profilePic
        let name = viewModel.name
        var userName = viewModel.userName
        
        
        if profilePic == "\(UserDefaultsProvider.shared.getIsometrikDefaultProfile())" || profilePic.isEmpty {
            profileView.isHidden = true
            defaultProfileView.isHidden = false
            let initials = "\(name.prefix(2))"
            defaultProfileView.initialsText.text = "\(initials)".uppercased()
        } else {
            profileView.isHidden = false
            defaultProfileView.isHidden = true
            if let url = URL(string: profilePic) {
                self.profileView.kf.setImage(with: url)
            }
        }
        
        titleLabel.text = "\(name)"
        descriptionLabel.text = "Requesting to Link with" + " " + "\(userName)."
        viewModel.requestTimer?.invalidate()
        viewModel.requestTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(requestTimerAction), userInfo: nil, repeats: true)
        viewModel.maximumWait = 15
        
    }
    
    // MARK: - ACTIONS
    
    @objc func requestTimerAction(){
        
        viewModel.maximumWait -= 1
        if viewModel.maximumWait == 1 {
            customLoader.stopAnimatingLoader()
            customLoader.isHidden = true
            descriptionLabel.text = "\(viewModel.userName)" + " " + "refused to link" + "."
            viewModel.requestTimer?.invalidate()
            dismissButton.isHidden = false
        }
        
    }
    
    @objc func dismissButtonTapped(){
        self.dismiss(animated: true)
    }


}
