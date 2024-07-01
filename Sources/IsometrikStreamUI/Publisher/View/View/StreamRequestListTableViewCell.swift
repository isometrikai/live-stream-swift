//
//  StreamRequestListTableViewCell.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 16/06/22.
//

import UIKit
import Kingfisher
import IsometrikStream

protocol StreamRequestListActionDelegate {
    func didAcceptActionTapped(_ index: Int)
    func didDeclineActionTapped(_ index: Int)
}

extension StreamRequestListActionDelegate {
    func didAcceptActionTapped(_ index: Int) {}
    func didDeclineActionTapped(_ index: Int) {}
}

class StreamRequestListTableViewCell: UITableViewCell {

    // MARK: - PROPERTIES
    
    var data: ISMRequest? {
        didSet {
            manageData()
        }
    }
    
    var delegate: StreamRequestListActionDelegate?
    
    let userProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    let defaultImageView: CustomDefaultProfileView = {
        let imageView = CustomDefaultProfileView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    let actionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    lazy var acceptButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Accept", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Appearance.default.colors.appColor
        button.titleLabel?.font = Appearance.default.font.getFont(forTypo: .h8)
        button.layer.cornerRadius = 15
        button.ismTapFeedBack()
        button.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var declineButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Decline", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Appearance.default.colors.appRed
        button.titleLabel?.font = Appearance.default.font.getFont(forTypo: .h8)
        button.layer.cornerRadius = 15
        button.ismTapFeedBack()
        button.addTarget(self, action: #selector(declineButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let statusLabelInfo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Appearance.default.font.getFont(forTypo: .h5)
        return label
    }()
    
    
    // MARK: - MAIN
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        backgroundColor = .clear
        addSubview(defaultImageView)
        addSubview(userProfileImage)
        addSubview(infoLabel)
        addSubview(actionStackView)
        actionStackView.addArrangedSubview(acceptButton)
        actionStackView.addArrangedSubview(declineButton)
        addSubview(statusLabelInfo)
    }
    
    func setupContraints(){
        NSLayoutConstraint.activate([
            userProfileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            userProfileImage.widthAnchor.constraint(equalToConstant: 50),
            userProfileImage.heightAnchor.constraint(equalToConstant: 50),
            userProfileImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            defaultImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            defaultImageView.widthAnchor.constraint(equalToConstant: 50),
            defaultImageView.heightAnchor.constraint(equalToConstant: 50),
            defaultImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            infoLabel.leadingAnchor.constraint(equalTo: userProfileImage.trailingAnchor, constant: 10),
            infoLabel.trailingAnchor.constraint(equalTo: actionStackView.leadingAnchor, constant: -5),
            infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            actionStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            actionStackView.heightAnchor.constraint(equalToConstant: 30),
            actionStackView.widthAnchor.constraint(equalToConstant: 150),
            actionStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            statusLabelInfo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            statusLabelInfo.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setAttributedText(name: String, userName:String, requestOn: Date) {
                
        let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(name)\n", attributes: [NSAttributedString.Key.font: Appearance.default.font.getFont(forTypo: .h6)!, NSAttributedString.Key.foregroundColor: UIColor.white]))
        
//        attributedText.append(NSAttributedString(string: "\(userName)\n", attributes: [NSAttributedString.Key.font: UIFont.ism_customFont(ofType: .regular, withSize: 12, enableAspectRatio: false), NSAttributedString.Key.foregroundColor: UIColor.white]))
        
        attributedText.append(NSAttributedString(string: "\(requestOn.ism_getCustomMessageTime())", attributes: [NSAttributedString.Key.font: Appearance.default.font.getFont(forTypo: .h8)! , NSAttributedString.Key.foregroundColor: UIColor.white]))
        
        
        infoLabel.attributedText = attributedText
    }
    
    func manageData(){
        guard let data = data else {
            return
        }
        
        
        let miliSecToSec = Int((data.requestTime ?? 0)/1000)
        let timeStamp = TimeInterval(miliSecToSec)
        let date = Date(timeIntervalSince1970: timeStamp)
        let userName = data.userName.unwrap
        let userProfilePic = data.userProfilePic
        
        if userProfilePic != UserDefaultsProvider.shared.getIsometrikDefaultProfile() {
            if let userProfilePic, let imageUrl = URL(string: userProfilePic) {
                userProfileImage.kf.setImage(with: imageUrl)
            }
        }
        
        defaultImageView.initialsText.text = "\(userName.prefix(2))".uppercased()
        setAttributedText(name: userName, userName: data.userIdentifier ?? "", requestOn: date)
        
        if let accepted = data.accepted , let pending = data.pending {
            if accepted {
                statusLabelInfo.text = "accepted".uppercased().ism_localized
                statusLabelInfo.textColor = .green
                actionStackView.isHidden = true
            } else if(!accepted && !pending) {
                statusLabelInfo.text = "declined".uppercased().ism_localized
                statusLabelInfo.textColor = .red
                actionStackView.isHidden = true
            } else {
                actionStackView.isHidden = false
                statusLabelInfo.text = ""
            }
        }
        
    }
    
    // MARK: - ACTIONS
    
    @objc func acceptButtonTapped(){
        guard let data = data else {
            return
        }
        delegate?.didAcceptActionTapped(self.tag)
    }
    
    @objc func declineButtonTapped(){
        guard let data = data else {
            return
        }
        delegate?.didDeclineActionTapped(self.tag)
    }

}
