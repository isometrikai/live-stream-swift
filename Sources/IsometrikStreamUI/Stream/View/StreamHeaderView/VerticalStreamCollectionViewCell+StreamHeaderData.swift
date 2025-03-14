//
//  VerticalStreamCollectionViewCell+StreamHeaderData.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 02/09/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit
import IsometrikStream

extension VerticalStreamCollectionViewCell: ISMAppearanceProvider {
    
    func setStreamHeaderView(){
        
        guard let viewModel else { return }
        
        let streamsData = viewModel.streamsData
        let isometrik = viewModel.isometrik
        
        guard let streamData = streamsData[safe: self.tag]
        else { return }
        
        let streamUserId = streamData.userDetails?.id ?? ""
        let streamStatus = LiveStreamStatus(rawValue: streamData.status ?? "STARTED")
        let currentUserId = isometrik.getUserSession().getUserId()
        
        let streamUserType = viewModel.streamUserType
        let headerView = streamContainer.streamHeaderView
        let streamTitleLabel = headerView.streamTitleLabel
        
        let headerProfileView = headerView.profileView
        let followButton = headerProfileView.followButton
        let moderatorButton = headerView.streamStatusView.moderatorButton
        let streamCartBadge = headerView.cartBadge
        let streamStatusView = headerView.streamStatusView
        let viewerCountView = headerView.viewerCountView
        let paidStreamButton = streamStatusView.paidStreamButton
        
        let isPKStream = streamData.isPkChallenge.unwrap
        let isPaidStream = streamData.isPaid.unwrap
        let paidAmount = streamData.amount.unwrap
        let userAccess = viewModel.streamUserAccess
        
        // if pk stream hide the title label otherwise not
        streamTitleLabel.isHidden = isPKStream

        streamTitleLabel.text = streamData.streamDescription.unwrap
        
        var hostMember: ISMMember?
        var userName: String?
        var firstName: String?
        var lastName: String?
        var profileImage: String?
        
        // updating schedule stream changes
        if streamStatus == .scheduled {
            
            let scheduleStartDate = Date(timeIntervalSince1970: Double(streamData.scheduleStartTime.unwrap))
            let scheduleStartDateString = scheduleStartDate.ism_getCustomMessageTime(dateFormat: "d MMM, hh:mm a").uppercased()
            
            streamStatusView.liveButton.setTitle("\(scheduleStartDateString)", for: .normal)
            streamStatusView.liveButton.setTitleColor(appearance.colors.appSecondary, for: .normal)
            streamStatusView.liveButton.backgroundColor = appearance.colors.appColor
            
            streamStatusView.memberFeatureView.isHidden = true
            
            headerView.cartButton(canBeShown: false)
            viewerCountView.iconImageView.image = appearance.images.rsvpdUser.withRenderingMode(.alwaysTemplate)
            
            headerView.viewerCountView.actionButton.isEnabled = false
            
        } else {
            
            streamStatusView.liveButton.setTitleColor(.white, for: .normal)
            streamStatusView.memberFeatureView.isHidden = false
            headerView.cartButton(canBeShown: false)
            viewerCountView.iconImageView.image = appearance.images.eye.withRenderingMode(.alwaysTemplate)
            
            headerView.viewerCountView.actionButton.isEnabled = true
            
        }
        
        // updating paid stream changes
        if isPaidStream {
            streamStatusView.stackView.addArrangedSubview(paidStreamButton)
            let amountLabel = Int64(paidAmount).ism_roundedWithAbbreviations
            paidStreamButton.setTitle("  \(amountLabel)", for: .normal)
        } else {
            streamStatusView.stackView.removeArrangedSubview(paidStreamButton)
        }
        
        // updating moderator changes
        if userAccess == .moderator {
            moderatorButton.isHidden = false
        } else {
            moderatorButton.isHidden = true
        }
        
        if streamStatus == .started {
            // updating stream profile changes
            switch streamUserType {
            case .viewer:

                let filteredMember = viewModel.streamMembers.filter { member in
                    member.isAdmin == true
                }
                hostMember = filteredMember.first
                
                if currentUserId != hostMember?.userID ?? "" {
                    //followButton.isHidden = false
                }
                
                userName = hostMember?.userName
                firstName = hostMember?.metaData?.firstName
                lastName = hostMember?.metaData?.lastName
                profileImage = hostMember?.userProfileImageURL

                self.setHeaderCartBadgeUpdates()
                
                break
            case .member:
                if currentUserId != hostMember?.userID ?? "" {
                    //followButton.isHidden = false
                }
                
                let filteredMember = viewModel.streamMembers.filter { member in
                    member.isAdmin == true
                }
                hostMember = filteredMember.first
                
                userName = hostMember?.userName
                firstName = hostMember?.metaData?.firstName
                lastName = hostMember?.metaData?.lastName
                profileImage = hostMember?.userProfileImageURL
                
                break
            case .host:

                let filteredMember = viewModel.streamMembers.filter { member in
                    member.userID == currentUserId
                }

                hostMember = filteredMember.first
                
                //followButton.isHidden = true
                
                userName = hostMember?.userName
                firstName = hostMember?.metaData?.firstName
                lastName = hostMember?.metaData?.lastName
                profileImage = hostMember?.userProfileImageURL

                break
            }
        } else if streamStatus == .scheduled {
            switch streamUserType {
            case .viewer:
                //followButton.isHidden = false
                userName = streamData.userDetails?.userName ?? ""
                break
            case .host:
                //followButton.isHidden = true
                
                userName = isometrik.getUserSession().getUserIdentifier()
                firstName = isometrik.getUserSession().getUserName()
                lastName = " "
                profileImage = isometrik.getUserSession().getUserImage()
                break
            default: break
            }
        }
        
        
        self.setFollowButtonStatus()
        
        if let firstName, let lastName, !firstName.isEmpty, !lastName.isEmpty {
            headerProfileView.profileName.isHidden = false
            headerProfileView.profileName.text = "\(firstName) \(lastName)"
        } else {
            headerProfileView.profileName.isHidden = true
        }
        
        if let userName {
            headerProfileView.userIdentifierLabel.isHidden = false
            headerProfileView.userIdentifierLabel.text = "\(userName)"
        } else {
            headerProfileView.userIdentifierLabel.isHidden = true
        }
        
        if profileImage != UserDefaultsProvider.shared.getIsometrikDefaultProfile() {
            if let profileImageURl = URL(string: profileImage ?? "") {
                headerProfileView.profileImage.kf.setImage(with: profileImageURl)
            } else {
                headerProfileView.profileImage.image = UIImage()
            }
        }
        
        if let firstName, let lastName {
            let initialText = "\(firstName.prefix(1))\(lastName.prefix(1))".uppercased()
            headerProfileView.defaultProfileView.initialsText.text = initialText
        } else {
            let initialText = "\(userName?.prefix(2) ?? "Un")".uppercased()
            headerProfileView.defaultProfileView.initialsText.text = initialText
        }
        
        // set stream members count view
        streamStatusView.memberFeatureView.featureLabel.text = "\(viewModel.streamMembers.count)"
        
        DispatchQueue.main.async {
//            headerView.animateViewersCount(withText: viewModel.streamViewerCount)
            headerView.animateViewersCount(withText: viewModel.streamViewers.count)
            
        }
        
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
        
        guard let viewModel else { return }
        
        let streamsData = viewModel.streamsData
        
        guard let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
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
