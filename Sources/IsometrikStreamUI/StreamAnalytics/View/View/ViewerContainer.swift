//
//  ViewerContainer.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 07/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

protocol StreamAnalyticViewersActionDelegate {
    func didTapFollowButtonTapped(index: Int)
}

class ViewerContainer: UIView, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var delegate: StreamAnalyticViewersActionDelegate?
    
    var viewers: [StreamAnalyticViewers] = [] {
        didSet {
            
            if viewers.count > 0 {
                defaultView.isHidden = true
                headerTitle.text = "Viewers".localized + "(\(viewers.count))"
            } else {
                defaultView.isHidden = false
                headerTitle.text = "Viewers".localized
            }
            
            self.viewerTableView.reloadData()
            
        }
        
    }
    
    lazy var headerTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Viewers".localized
        label.font = appearance.font.getFont(forTypo: .h5)
        return label
    }()
    
    lazy var viewerTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DynamicUserInfoTableViewCell.self, forCellReuseIdentifier: "DynamicUserInfoTableViewCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = UIColor.lightGray.withAlphaComponent(0.2)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: ism_windowConstant.getBottomPadding + 100, right: 0)
        return tableView
    }()
    
    lazy var defaultView: StreamDefaultEmptyView = {
        let view = StreamDefaultEmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.defaultImageView.image = appearance.images.noViewers
        view.defaultLabel.text = "No Viewers Found".localized
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
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        addSubview(headerTitle)
        addSubview(defaultView)
        addSubview(viewerTableView)
    }
    
    func setupConstraints(){
        defaultView.ism_pin(to: self)
        NSLayoutConstraint.activate([
            headerTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            headerTitle.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            
            viewerTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewerTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewerTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            viewerTableView.topAnchor.constraint(equalTo: headerTitle.bottomAnchor)
        ])
    }

}

extension ViewerContainer: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DynamicUserInfoTableViewCell", for: indexPath) as! DynamicUserInfoTableViewCell
        
        let viewerData = viewers[indexPath.row]
        let userId = viewerData.appUserID.unwrap
        let firstName = viewerData.userMetaData?.firstName ?? ""
        let lastName = viewerData.userMetaData?.lastName ?? ""
        let userName = viewerData.userName.unwrap
        
        var name = ""
        
        if !firstName.isEmpty && !lastName.isEmpty {
            name = (firstName + " " + lastName)
        } else {
            name = userName
        }
        
        let image = viewerData.profilePic.unwrap
        let followStatus = viewerData.followStatus.unwrap
        let privacy = viewerData.privacy.unwrap
        
        cell.titleLabel.textColor = .black
        
        cell.userData = ISMStreamUser(
            userId: userId,
            identifier: userName,
            name: name,
            imagePath: image,
            followStatus: followStatus,
            privacy: privacy
        )
        
        cell.actionButton.setTitle("Follow", for: .normal)
        
//        let status = FollowStatusCode(rawValue: followStatus)
//        switch status {
//        case .follow:
//            cell.actionButton.setTitle("Follow".localized, for: .normal)
//            cell.actionButton.backgroundColor = .black
//            cell.actionButton.setTitleColor(.white, for: .normal)
//            cell.actionButton.layer.borderWidth = 0
//            break
//        case .following:
//            cell.actionButton.setTitle("Following".localized, for: .normal)
//            cell.actionButton.backgroundColor = .white
//            cell.actionButton.setTitleColor(.black, for: .normal)
//            cell.actionButton.layer.borderColor = UIColor.black.cgColor
//            cell.actionButton.layer.borderWidth = 1
//            break
//        case .requested:
//            cell.actionButton.setTitle("Requested".localized, for: .normal)
//            cell.actionButton.backgroundColor = .white
//            cell.actionButton.setTitleColor(.black, for: .normal)
//            cell.actionButton.layer.borderColor = UIColor.black.cgColor
//            cell.actionButton.layer.borderWidth = 1
//            break
//        case nil:
//            break
//        }
        
        cell.actionButton_callback = { [weak self] userData in
            guard let self else { return }
            self.delegate?.didTapFollowButtonTapped(index: indexPath.row)
        }
        
        cell.selectionStyle = .none
        cell.contentView.isUserInteractionEnabled = false
        cell.actionButtonWidth?.constant = 100
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
