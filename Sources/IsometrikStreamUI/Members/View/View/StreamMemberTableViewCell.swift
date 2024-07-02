//
//  StreamMemberTableViewCell.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 26/04/22.
//

import UIKit
import IsometrikStream
import Kingfisher

protocol StreamMemberListActionDelegate {
    func didkickoutMemberTapped(member: ISMMember)
    func didMemberTapped(withId memberId: String)
    func didAddMemberTapped(member: ISMMember, index: Int)
    func didRemoveMemberTapped(member: ISMMember, index: Int)
}

extension StreamMemberListActionDelegate {
    func didkickoutMemberTapped(member: ISMMember){}
    func didMemberTapped(withId memberId: String){}
    func didAddMemberTapped(member: ISMMember, index: Int){}
    func didRemoveMemberTapped(member: ISMMember, index: Int){}
    func didUpdateMembers(member: [ISMMember]){}
}

class StreamMemberTableViewCell: UITableViewCell, AppearanceProvider {

    // MARK: - PROPERTIES
    
    var isometrik: IsometrikSDK?
    var delegate: StreamMemberListActionDelegate?
    var isGoLiveWith: Bool = false
    var member: ISMMember?
    
    lazy var userProfile: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerCurve = .continuous
        imageView.layer.cornerRadius = 25
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        
        return imageView
    }()
    
    let userDefaultProfile: CustomDefaultProfileView = {
        let imageView = CustomDefaultProfileView()
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    let userInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h8)
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .lightGray
        label.font = appearance.font.getFont(forTypo: .h8)
        label.numberOfLines = 0
        return label
    }()
    
    let statusView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 5
        view.isHidden = true
        return view
    }()
    
    lazy var userType: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Host", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h8)
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 15
        button.backgroundColor = appearance.colors.appColor
        button.addTarget(self, action:  #selector(userTypeTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    // MARK: - MAIN
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        addSubview(userDefaultProfile)
        addSubview(userProfile)
        addSubview(userInfoStackView)
        
        userInfoStackView.addArrangedSubview(titleLabel)
        userInfoStackView.addArrangedSubview(subtitleLabel)
        
        addSubview(userType)
        addSubview(statusView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            
            userDefaultProfile.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            userDefaultProfile.widthAnchor.constraint(equalToConstant: 50),
            userDefaultProfile.heightAnchor.constraint(equalToConstant: 50),
            userDefaultProfile.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            userProfile.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            userProfile.widthAnchor.constraint(equalToConstant: 50),
            userProfile.heightAnchor.constraint(equalToConstant: 50),
            userProfile.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            userInfoStackView.leadingAnchor.constraint(equalTo: userProfile.trailingAnchor, constant: 10),
            userInfoStackView.trailingAnchor.constraint(equalTo: userType.leadingAnchor, constant: -10),
            userInfoStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            userType.centerYAnchor.constraint(equalTo: centerYAnchor),
            userType.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            userType.widthAnchor.constraint(equalToConstant: 60),
            userType.heightAnchor.constraint(equalToConstant: 30),
            
            statusView.trailingAnchor.constraint(equalTo: userType.leadingAnchor, constant: -10),
            statusView.widthAnchor.constraint(equalToConstant: 10),
            statusView.heightAnchor.constraint(equalToConstant: 10),
            statusView.centerYAnchor.constraint(equalTo: centerYAnchor)
            
        ])
    }
    
    func configureCell(member memberData: ISMMember?){
        guard var memberData = memberData,
              let isHost = memberData.isAdmin,
              let isPublishing = memberData.isPublishing
        else {
            return
        }
        
        let firstName = memberData.metaData?.firstName ?? ""
        let lastName = memberData.metaData?.lastName ?? ""
        let userName = memberData.userName ?? ""
        let fullName = "\(firstName) \(lastName)"
        
        self.member = memberData
        
        userProfile.image = UIImage()
        
        if isHost {
            userType.isHidden = false
            userType.backgroundColor = appearance.colors.appColor
            userType.setTitle("Host", for: .normal)
            
            if isPublishing {
                statusView.isHidden = false
                statusView.backgroundColor = appearance.colors.appGreen
            }
            
        } else {
            if isPublishing {
                userType.isHidden = true
                statusView.isHidden = false
                statusView.backgroundColor = appearance.colors.appGreen
            } else {
                
                if isGoLiveWith {
                    let currentUserType = isometrik?.getUserSession().getUserType()
                    if currentUserType == .host {
                        userType.isHidden = false
                        userType.backgroundColor = appearance.colors.appColor
                        userType.setTitle("Add", for: .normal)
                    } else {
                        userType.isHidden = true
                    }
                } else {
                    userType.isHidden = true
                }
                
                statusView.isHidden = false
                statusView.backgroundColor = appearance.colors.appRed
                
            }
        }
        
        if let imagePath = memberData.metaData?.profilePic {
            if imagePath != UserDefaultsProvider.shared.getIsometrikDefaultProfile() {
                if let imagePathUrl = URL(string: imagePath){
                    userProfile.kf.setImage(with: imagePathUrl)
                }
            } else {
                userProfile.image = UIImage()
            }
        } else {
            userProfile.image = UIImage()
        }
        
        titleLabel.text = fullName
        userDefaultProfile.initialsText.text = String(fullName.prefix(2).uppercased())
        
        if isGoLiveWith {
            
            /**
             
             if let userIdentifier = memberData.identifier {
                 subtitleLabel.text = userIdentifier
             }
             
             */
            
            subtitleLabel.text = ""
            
        } else {
            
            var subtitleText = ""
            
            if let userIdentifier = memberData.userName  {
                
                let joinTime = memberData.joinTime ?? 0
                
                if joinTime != 0 {
                    let unix = Int(joinTime / 1000) // milisecond to second conversion
                    let date = Date(timeIntervalSince1970: TimeInterval(unix))
                    let dateString = date.ism_getCustomMessageTime()
                    //subtitleText += userIdentifier + "\n\(dateString)"
                    subtitleText += "\(dateString)"
                } else {
                    //subtitleText += userIdentifier
                    subtitleText += ""
                }
                
            }
            
            if !isPublishing {
                subtitleText += "\nNot Publishing"
            }
            
            subtitleLabel.text = subtitleText
        }
        
    }
    
    // MARK: - ACTIONS
    
    @objc func userTypeTapped(){
        guard let member = member else {
            return
        }
        
        let isHost = member.isAdmin ?? false
        let isPublishing = member.isPublishing ?? false
        
        if isHost {
            // do nothing
        } else {
            if isPublishing {
                delegate?.didkickoutMemberTapped(member: member)
            } else {
                if isGoLiveWith {
                    delegate?.didAddMemberTapped(member: member, index: self.tag)
                } else {
                    // remove member
                }
            }
        }
        
    }
    
    @objc func profileTapped(){
        
        guard var member = member else {
            return
        }
        
        delegate?.didMemberTapped(withId: member.userID ?? "")
        
    }

}
