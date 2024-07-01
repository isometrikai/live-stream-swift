//
//  StreamViewerTableViewCell.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 26/04/22.
//

import UIKit
import Kingfisher
import IsometrikStream

protocol StreamViewerActionDelegate {
    func didActionButtonTapped(with index: Int, with data: ISMViewer, actionType: ActionType)
    func didViewerTapped(with user: ISMViewer?, navigationController: UINavigationController?)
}

enum ActionType {
    case add
    case kickout
}

class StreamViewerTableViewCell: UITableViewCell {

    // MARK: - PROPERTIES
    
    var userType: StreamUserType?
    var isometrik: IsometrikSDK?
    var delegate: StreamViewerActionDelegate?
    var data: ISMViewer? {
        didSet {
            manageData()
        }
    }
    var actionType: ActionType = .kickout
    
    let defaultProfile: CustomDefaultProfileView = {
        let view = CustomDefaultProfileView()
        view.layer.cornerRadius = 25
        return view
    }()
    
    let userProfile: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerCurve = .continuous
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let userInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .black
        label.font = Appearance.default.font.getFont(forTypo: .h8)
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "user@isometrik.io \nToday 12:34 AM"
        label.textColor = .lightGray
        label.font = Appearance.default.font.getFont(forTypo: .h8)
        label.numberOfLines = 0
        return label
    }()
    
    let joiningLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = Appearance.default.font.getFont(forTypo: .h8)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Kickout".ism_localized, for: .normal)
        button.titleLabel?.font = Appearance.default.font.getFont(forTypo: .h6)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 15
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
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
    
    // MARK: - FUNTIONS
    
    func setupViews(){
        self.backgroundColor = .clear
        addSubview(defaultProfile)
        addSubview(userProfile)
        addSubview(userInfoStackView)
        
        userInfoStackView.addArrangedSubview(titleLabel)
        userInfoStackView.addArrangedSubview(subtitleLabel)
        userInfoStackView.addArrangedSubview(joiningLabel)
        
        addSubview(actionButton)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            
            defaultProfile.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            defaultProfile.widthAnchor.constraint(equalToConstant: 50),
            defaultProfile.heightAnchor.constraint(equalToConstant: 50),
            defaultProfile.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            userProfile.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            userProfile.widthAnchor.constraint(equalToConstant: 50),
            userProfile.heightAnchor.constraint(equalToConstant: 50),
            userProfile.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            userInfoStackView.leadingAnchor.constraint(equalTo: userProfile.trailingAnchor, constant: 10),
            userInfoStackView.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -10),
            userInfoStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            actionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            actionButton.widthAnchor.constraint(equalToConstant: 80),
            actionButton.heightAnchor.constraint(equalToConstant: 30)
            
        ])
    }
    
    func getReadableDate(timeStamp: TimeInterval) -> String? {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        
        if Calendar.current.isDateInTomorrow(date) {
            return "Tomorrow"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else if dateFallsInCurrentWeek(date: date) {
            if Calendar.current.isDateInToday(date) {
                dateFormatter.dateFormat = "h:mm a"
                return dateFormatter.string(from: date)
            } else {
                dateFormatter.dateFormat = "EEEE"
                return dateFormatter.string(from: date)
            }
        } else {
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: date)
        }
    }
    
    func dateFallsInCurrentWeek(date: Date) -> Bool {
        let currentWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: Date())
        let datesWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: date)
        return (currentWeek == datesWeek)
    }
    
    func manageData(){
        
        guard let data,
              let isometrik,
              let userType
        else {
            return
        }
        
        userProfile.image = UIImage()
        
        let timeInterval = TimeInterval(data.joinTime ?? 0)
        let customDate = Date(timeIntervalSince1970: timeInterval / 1000)
        let time = customDate.ism_getCustomMessageTime()
        
        
        if data.imagePath != UserDefaultsProvider.shared.getIsometrikDefaultProfile() {
            if let imageUrl = URL(string: data.imagePath ?? "") {
                userProfile.kf.setImage(with: imageUrl)
            } else {
                userProfile.image = UIImage()
            }
        } else {
            userProfile.image = UIImage()
        }
        
        titleLabel.text = data.name
        if let username = data.name {
            defaultProfile.initialsText.text = username.prefix(2).uppercased()
        }
        
        subtitleLabel.text = ""
        joiningLabel.text = "\(time)"
        
        
        if userType == .viewer {
            actionButton.isHidden = true
        } else if userType == .host || userType == .moderator {
            actionButton.isHidden = false
            switch actionType {
            case .add:
                actionButton.setTitle("Add", for: .normal)
            case .kickout:
                
                // if user itself then hide
                let currentUserId = isometrik.getUserSession().getUserId()
                
                if currentUserId != (data.viewerId ?? "") {
                    actionButton.setTitle("Kickout", for: .normal)
                } else {
                    actionButton.isHidden = true
                }
                
            }
        } else {
            actionButton.isHidden = true
        }
        
    }
    
    // MARK: - ACTIONS
    
    @objc func actionButtonTapped(){
        guard let data = data else {
            return
        }
        delegate?.didActionButtonTapped(with: self.tag, with: data, actionType: actionType)
    }

}
