//
//  StreamViewController+StreamUserProfileAction.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 09/02/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

extension StreamViewController: StreamUserProfileDelegate {
    
    func didUserProfileOptionTapped(actionType: UserProfileActionType, messageData: ISMComment?) {
        
        guard let isometrik = viewModel.isometrik,
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row],
              let messageData
        else { return }
        
        let streamId = streamData.streamId.unwrap
        let streamerIsometrikUserId = streamData.userDetails?.isomatricChatUserId ?? ""
        let isometrikUserId = messageData.senderId.unwrap
        let appUserId = messageData.metaData?.userId ?? ""
        
        switch actionType {
        case .kickout:
            // Kickout a viewer
            
            isometrik.getIsometrik().removeViewer(streamId: streamId, viewerId:isometrikUserId, initiatorId: streamerIsometrikUserId) { viewer in
                print(viewer)
            } failure: { error in
                print(error)
            }
            
            break
        case .makeModerator:
            // Make user moderator
            
            isometrik.getIsometrik().addModerator(streamId: streamId, moderatorId:isometrikUserId, initiatorId: streamerIsometrikUserId) { viewer in
                print(viewer)
            } failure: { error in
                print(error)
            }
            
            break
        case .report:
            // report a user
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                
                let controller = StreamReportViewController()
                //controller.userViewModel.userId = appUserId
                controller.modalPresentationStyle = .pageSheet
                
                if #available(iOS 15.0, *) {
                    if #available(iOS 16.0, *) {
                        controller.sheetPresentationController?.prefersGrabberVisible = false
                        controller.sheetPresentationController?.detents = [
                            .custom(resolver: { context in
                                return 250 + ism_windowConstant.getBottomPadding
                            })
                        ]
                    }
                }
                
                self.present(controller, animated: true)
                
            }
            
            break
        case .block:
            // block a user
            
            break
        }
        
    }
    
}
