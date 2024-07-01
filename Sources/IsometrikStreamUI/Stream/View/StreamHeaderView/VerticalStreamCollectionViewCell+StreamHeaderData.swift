//
//  VerticalStreamCollectionViewCell+StreamHeaderData.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 02/09/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit
import IsometrikStream

extension VerticalStreamCollectionViewCell: AppearanceProvider {
    
    func setStreamHeaderView(){
        
        guard let viewModel,
              let streamsData = viewModel.streamsData,
              let isometrik = viewModel.isometrik,
              let streamData = streamsData[safe: self.tag]
        else { return }
        
        let streamViewersCount = viewModel.streamViewers.count
        let streamStatus = LiveStreamStatus(rawValue: streamData.status ?? "STARTED")
        let currentUserId = isometrik.getUserSession().getUserId()
        
        let streamUserType = viewModel.streamUserType
        let headerView = streamContainer.streamHeaderView
        let streamTitleLabel = headerView.streamTitleLabel
        
        let followButton = headerView.profileView.followButton
        let moderatorButton = headerView.streamStatusView.moderatorButton
//        let streamCartView = headerView.cartView
//        let streamCartButton = headerView.cartButton
        let streamCartBadge = headerView.cartBadge
        let streamStatusView = headerView.streamStatusView
        let viewerCountView = headerView.viewerCountView
        let isPKStream = streamData.isPkChallenge.unwrap
        
        // if pk stream hide the title label otherwise not
        streamTitleLabel.isHidden = isPKStream

        streamTitleLabel.text = streamData.streamDescription.unwrap
        headerView.animateViewersCount(withText: streamViewersCount)
        
        var hostMember: ISMMember?
        var userName: String?
        var firstName: String?
        var lastName: String?
        var profileImage: String?
        
        if streamStatus == .scheduled {
            streamStatusView.isHidden = true
            headerView.cartButton(canBeShown: true)
            viewerCountView.iconImageView.image = appearance.images.rsvpUser.withRenderingMode(.alwaysTemplate)
        } else {
            streamStatusView.isHidden = false
            headerView.cartButton(canBeShown: false)
            viewerCountView.iconImageView.image = appearance.images.eye.withRenderingMode(.alwaysTemplate)
        }
        
        switch streamUserType {
        case .viewer:

            let filteredMember = viewModel.streamMembers.filter { member in
                member.userID == streamData.isometrikUserID
            }
            hostMember = filteredMember.first
            
            if currentUserId != hostMember?.userID ?? "" {
                followButton.isHidden = false
            }
            
            moderatorButton.isHidden = true
            
            userName = streamData.userDetails?.userName ?? hostMember?.userName ?? streamData.initiatorIdentifier ?? ""
            firstName = streamData.userDetails?.firstName ?? hostMember?.userName ?? streamData.initiatorName ?? ""
            lastName = streamData.userDetails?.lastName ?? hostMember?.userName ?? ""
            profileImage = streamData.userDetails?.profilePic ?? hostMember?.userProfileImageURL ?? streamData.initiatorimage ?? ""

            self.setHeaderCartBadgeUpdates()
            
            break
        case .member:
            if currentUserId != hostMember?.userID ?? "" {
                followButton.isHidden = false
            }
            
            let filteredMember = viewModel.streamMembers.filter { member in
                member.userID == streamData.isometrikUserID
            }
            hostMember = filteredMember.first
            
            userName = streamData.userDetails?.userName ?? hostMember?.userName ?? streamData.initiatorIdentifier ?? ""
            firstName = streamData.userDetails?.firstName ?? hostMember?.metaData?.firstName ?? streamData.initiatorName ?? ""
            lastName = streamData.userDetails?.lastName ?? hostMember?.metaData?.lastName ?? ""
            profileImage = streamData.userDetails?.profilePic ?? hostMember?.userProfileImageURL ?? streamData.initiatorimage ?? ""
            
            break
        case .host:

            let filteredMember = viewModel.streamMembers.filter { member in
                member.userID == currentUserId
            }

            hostMember = filteredMember.first
            
            followButton.isHidden = true
            moderatorButton.isHidden = false
            
            userName = isometrik.getUserSession().getUserIdentifier()
            firstName = isometrik.getUserSession().getFirstName()
            lastName = isometrik.getUserSession().getLastName()
            
            if isometrik.getUserSession().getFirstName().isEmpty && isometrik.getUserSession().getLastName().isEmpty {
                userName = isometrik.getUserSession().getUserName()
            }
            
            profileImage = hostMember?.userProfileImageURL ?? ""

            break
        case .moderator:
            
            let filteredMember = viewModel.streamMembers.filter { member in
                member.userID == streamData.isometrikUserID
            }
            
            hostMember = filteredMember.first
            
            if currentUserId != hostMember?.userID ?? "" {
                followButton.isHidden = false
            }
            
            moderatorButton.isHidden = false
            
            userName = streamData.userDetails?.userName ?? (hostMember?.userName ?? "")
            firstName = streamData.userDetails?.firstName ?? (hostMember?.userName ?? "")
            lastName = streamData.userDetails?.lastName ?? (hostMember?.userName ?? "")
            profileImage = streamData.userDetails?.profilePic ?? (hostMember?.userProfileImageURL ?? "")
            
            break
        }
        
        self.setFollowButtonStatus()
        
        headerView.profileView.profileName.text = "\(firstName ?? "") \(lastName ?? "")"
        headerView.profileView.userIdentifierLabel.text = "\(userName ?? "")"

        if profileImage != UserDefaultsProvider.shared.getIsometrikDefaultProfile() {
            if let profileImageURl = URL(string: profileImage ?? "") {
                headerView.profileView.profileImage.kf.setImage(with: profileImageURl)
            } else {
                headerView.profileView.profileImage.image = UIImage()
            }
        }
        
        let initialText = "\(firstName?.prefix(1) ?? "U")\(lastName?.prefix(1) ?? "n")".uppercased()
        headerView.profileView.defaultProfileView.initialsText.text = initialText
        
    }
    
    func updateLiveConnectionStatus(connectionStatus: Bool){
        
        let statusView = streamContainer.streamHeaderView.streamStatusView
        statusView.liveButton.setTitle(connectionStatus ? "LIVE" : "connecting", for: .normal)
        statusView.liveButton.backgroundColor = connectionStatus ? appearance.colors.appGreen : .red
        
        if connectionStatus {
            UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse]) {
                statusView.liveButton.transform = .init(scaleX: 0.95, y: 0.95)
                statusView.liveButton.alpha = 0.8
            }
        }
        
    }
    
    func setHeaderCartBadgeUpdates(){
        
//        let cartBadge = streamContainer.streamHeaderView.cartBadge
//        
//        if CartVM.cartProducts.count > 0{
//            cartBadge.setTitle("\(CartVM.cartProducts.count)", for: .normal)
//            cartBadge.isHidden = (CartVM.cartProducts.count == 0)
//        }else{
//            cartBadge.isHidden = true
//        }
        
    }
    
    func setFollowButtonStatus(){
        
        guard let viewModel,
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let headerView = streamContainer.streamHeaderView
        let followButton = headerView.profileView.followButton
        
        let followStatusCode = streamData.userDetails?.followStatus ?? 0
//        let followStatus = FollowStatusCode(rawValue: followStatusCode)
        
//        switch followStatus {
//        case .follow:
//            followButton.setImage(UIImage(named: "ism_follow")?.withRenderingMode(.alwaysTemplate), for: .normal)
//            followButton.imageView?.tintColor = .white
//            break
//        case .following:
//            followButton.setImage(UIImage(named: "ism_following")?.withRenderingMode(.alwaysTemplate), for: .normal)
//            followButton.imageView?.tintColor = .white
//            break
//        case .requested:
//            followButton.setImage(UIImage(named: "ism_requested")?.withRenderingMode(.alwaysTemplate), for: .normal)
//            followButton.imageView?.tintColor = .white
//            break
//        case nil:
//            break
//        }
        
    }
    
}
