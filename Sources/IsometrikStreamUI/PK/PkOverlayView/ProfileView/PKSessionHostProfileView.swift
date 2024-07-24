//
//  PKSessionHostProfileView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 06/12/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import UIKit
import Kingfisher
import IsometrikStream

class PKSessionHostProfileView: UIView, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var data: ISMMember? {
        didSet {
            manageData()
        }
    }
    
    let pkProfileOverlay: PKHostProfileOverlayView = {
        let view = PKHostProfileOverlayView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 17.5
        imageView.layer.borderColor = appearance.colors.appPink.cgColor
        imageView.layer.borderWidth = 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var defaultProfileImageView: CustomDefaultProfileView = {
        let imageView = CustomDefaultProfileView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 17.5
        imageView.layer.borderColor = appearance.colors.appPink.cgColor
        imageView.layer.borderWidth = 2
        return imageView
    }()
    
    let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@tannvi"
        label.textColor = .white
        label.textAlignment = .left
        label.font = appearance.font.getFont(forTypo: .h7)
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Host".localized
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h8)
        label.textAlignment = .left
        return label
    }()
    
    let gradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - MAIN
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setLeftConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNTIONS
    
    func setupViews(){
        addSubview(gradientView)
        addSubview(pkProfileOverlay)
        
        addSubview(defaultProfileImageView)
        addSubview(profileImageView)
        
        addSubview(infoStackView)
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(subtitleLabel)
    }
    
    func setLeftConstraints(){
        gradientView.ism_pin(to: self)
        pkProfileOverlay.ism_pin(to: self)
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 35),
            profileImageView.heightAnchor.constraint(equalToConstant: 35),
            
            defaultProfileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            defaultProfileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            defaultProfileImageView.widthAnchor.constraint(equalToConstant: 35),
            defaultProfileImageView.heightAnchor.constraint(equalToConstant: 35),
            
            infoStackView.leadingAnchor.constraint(equalTo: defaultProfileImageView.trailingAnchor, constant: 5),
            infoStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
    }
    
    func manageData(){
        guard let data = data else { return }
        
        if data.metaData?.profilePic.unwrap != UserDefaultsProvider.shared.getIsometrikDefaultProfile() {
            
            if let profileURL = URL(string: data.metaData?.profilePic ?? "") {
                profileImageView.kf.setImage(with: profileURL)
                pkProfileOverlay.profileImageView.kf.setImage(with: profileURL)
            } else {
                profileImageView.image = UIImage()
                pkProfileOverlay.profileImageView.image = UIImage()
            }
            
        } else {
            profileImageView.image = UIImage()
            pkProfileOverlay.profileImageView.image = UIImage()
        }
        
        if let userName = data.userName {
            
            let initialText = userName.prefix(2)
            defaultProfileImageView.initialsText.text = "\(initialText)".uppercased()
            pkProfileOverlay.defaultProfileImageView.initialsText.text = "\(initialText)".uppercased()
            
        }
        
        titleLabel.text = "@\(data.userName ?? "")"
        pkProfileOverlay.playerName.text = "@\(data.userName ?? "")"
        
        subtitleLabel.text = data.isAdmin ?? false ? "Host".localized : "Guest".localized
        
        DispatchQueue.main.async {
            self.gradientView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            self.gradientView.ism_setGradient(withColors: [UIColor.black.withAlphaComponent(0.7).cgColor, UIColor.clear.cgColor], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 0))
        }
        
    }
    
    func toggleToPKProfileView(toggle: Bool){
        if toggle {
            pkProfileOverlay.isHidden = false
            defaultProfileImageView.isHidden = true
            profileImageView.isHidden = true
            infoStackView.isHidden = true
        } else {
            pkProfileOverlay.isHidden = true
            defaultProfileImageView.isHidden = false
            profileImageView.isHidden = false
            infoStackView.isHidden = false
        }
    }


}

class PKHostProfileOverlayView: UIView, ISMAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    var labelPositionConstraints: NSLayoutConstraint?
    
    let profileView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var hostTag: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = appearance.colors.appRed
        view.setTitle("  Host  ", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = appearance.font.getFont(forTypo: .h8)
        view.layer.cornerRadius = 3
        return view
    }()
    
    lazy var ringImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = appearance.images.hostRing
        return imageView
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let defaultProfileImageView: CustomDefaultProfileView = {
        let imageView = CustomDefaultProfileView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    lazy var playerName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@tannvi"
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h7)
        label.textAlignment = .left
        return label
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
        
        addSubview(profileView)
        addGlowView()
        profileView.addSubview(defaultProfileImageView)
        profileView.addSubview(profileImageView)
        profileView.addSubview(ringImageView)
        profileView.addSubview(hostTag)
        addSubview(playerName)
        
    }
    
    func addGlowView(){
        let glowView = UIView(frame: CGRect(x: 0, y: 0, width: 65, height: 60))
        glowView.layer.shadowOffset = .zero
        glowView.layer.shadowColor = appearance.colors.appPink.cgColor
        glowView.layer.shadowRadius = 10
        glowView.layer.shadowOpacity = 0.5
        glowView.layer.shadowPath = UIBezierPath(rect: glowView.bounds).cgPath
        profileView.addSubview(glowView)
    }
    
    func setupConstraints(){
        ringImageView.ism_pin(to: profileView)
        NSLayoutConstraint.activate([
            
            hostTag.centerXAnchor.constraint(equalTo: profileView.centerXAnchor),
            hostTag.bottomAnchor.constraint(equalTo: profileView.bottomAnchor, constant: -2),
            hostTag.heightAnchor.constraint(equalToConstant: 12),
            
            profileView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            profileView.bottomAnchor.constraint(equalTo: bottomAnchor),
            profileView.widthAnchor.constraint(equalToConstant: 65),
            profileView.heightAnchor.constraint(equalToConstant: 60),
            
            profileImageView.centerXAnchor.constraint(equalTo: profileView.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: profileView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            
            defaultProfileImageView.centerXAnchor.constraint(equalTo: profileView.centerXAnchor),
            defaultProfileImageView.centerYAnchor.constraint(equalTo: profileView.centerYAnchor),
            defaultProfileImageView.widthAnchor.constraint(equalToConstant: 50),
            defaultProfileImageView.heightAnchor.constraint(equalToConstant: 50),
            
            playerName.leadingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: 8),
            playerName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
            
        ])
        
        labelPositionConstraints = playerName.topAnchor.constraint(equalTo: topAnchor, constant: 2)
        labelPositionConstraints?.isActive = true
    }
    
}
