//
//  VerticalStreamCollectionViewCell+StreamOptions.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 08/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit
import IsometrikStream

extension VerticalStreamCollectionViewCell {
    
    func setupStreamOptions(){
        
        guard let viewModel = viewModel,
              let isometrik = viewModel.isometrik,
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let streamUserType = viewModel.streamUserType
        let liveStreamStatus = LiveStreamStatus(rawValue:streamData.status)
        let streamMembers = viewModel.streamMembers
        let isPKEnabled = isometrik.isPKBattlesEnabled()
        
        // PK flags
        let isPKStream = streamData.isPkChallenge.unwrap
        let pkIdExist = !streamData.pkId.unwrap.isEmpty // this means battle on
        //:
        
        // RTMP Stream flags
        let isRTMPIngest = streamData.rtmpIngest.unwrap
        //:
        
        // Current user member list check
        let currentUserId = isometrik.getUserSession().getUserId()
        let isInMemberList = streamMembers.filter { member in
            return member.userID == currentUserId
        }
        let currentUserInMemberList: Bool = isInMemberList.count > 0
        //:
        
        /*
         
         [.bidder, .camera, .microphone, .store, .share, .highlight, .loved, .speaker , .report, .wallet, .analytics, .request, .requestList, .gift, .pkInvite, .endPKInvite, .stopPKBattle, .groupInvite, .startPublishing]
         
         */
        
        switch liveStreamStatus {
        case .started:
            
            /**
                Handling the stack options based on the user type.
             */

            switch streamUserType {
            case .viewer:
                
                if isRTMPIngest {
                    viewModel.streamOptions = [.gift, .share, .request]
                } else {
                    viewModel.streamOptions = [.gift, .share, .loved]
                    if !isPKStream {
                        if streamMembers.count > 0 {
                            if currentUserInMemberList {
                                viewModel.streamOptions += [.startPublishing]
                            } else {
                                viewModel.streamOptions += [.request]
                            }
                        } else {
                            viewModel.streamOptions += [.request]
                        }
                    }
                }
                
                
                break
            case .member:
                
                viewModel.streamOptions = [.share, .settings, .camera]
                
                if isPKStream {
                    viewModel.streamOptions += [.analytics]
                    if pkIdExist {
                        viewModel.streamOptions += [.stopPKBattle]
                    } else {
                        viewModel.streamOptions += [.endPKInvite]
                    }
                }
                
                break
            case .host:
                
                if isRTMPIngest {
                    viewModel.streamOptions = [.requestList, .groupInvite, .rtmpIngest]
                } else {
                    viewModel.streamOptions = [.share, .settings, .camera, .analytics]
                    
                    if isPKEnabled {
                        if isPKStream {
                            if pkIdExist {
                                viewModel.streamOptions += [.stopPKBattle]
                            } else {
                                viewModel.streamOptions += [.endPKInvite]
                            }
                        } else {
                            if streamMembers.count == 1 {
                                viewModel.streamOptions += [.pkInvite]
                            }
                            viewModel.streamOptions += [.requestList, .groupInvite]
                        }
                    } else {
                        viewModel.streamOptions += [.request, .requestList, .groupInvite]
                    }
                }
                
                break
            case .moderator:
                viewModel.streamOptions = [.loved, .share, .settings]
                break
            }
            
            // TODO: if ecommerce enabled then 250 px on the {spacing}
            //self.streamContainer.streamOptionViewBottomConstraints?.constant = -(50 + ism_windowConstant.getBottomPadding + {spacing}})
            
            self.streamContainer.streamOptionViewBottomConstraints?.constant = -(50 + ism_windowConstant.getBottomPadding + 30)
            
            break
        case .scheduled:
            
            /**
             Need to handle the stack options based on the user type.
             */

            switch streamUserType {
            case .viewer:
                viewModel.streamOptions = [.share, .store, .settings]
                break
            case .host:
                viewModel.streamOptions = [.share, .store, .more]
                break
            default:
                print("nothing")
            }
            
            self.streamContainer.streamOptionViewBottomConstraints?.constant = -(50 + ism_windowConstant.getBottomPadding + 30)
            
            break
        default:
            print("nothing")
        }
        
        for view in self.streamContainer.streamOptionsView.optionStackView.subviews {
            guard let view = view as? CustomStreamOptionView else { return }
            view.isHidden = !(viewModel.streamOptions.contains { $0.rawValue == view.optionButton.tag })
        }
        
    }
    
}
