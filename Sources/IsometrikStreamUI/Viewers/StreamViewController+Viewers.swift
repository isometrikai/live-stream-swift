//
//  StreamViewController+Viewers.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 31/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit
import IsometrikStream

/**
    Extension to manage the `Viewer` used in the `StreamViewController` class
 */

extension StreamViewController {
    
    func joinStreamAsViewer(streamData: ISMStream , cell: VerticalStreamCollectionViewCell?, _ completion: @escaping (_ success: Bool?, _ errorString: String?)->Void){
        
        guard let cell
        else { return }
        
        let isometrik = viewModel.isometrik
        let userId = isometrik.getUserSession().getUserId()
        let streamId = streamData.streamId.unwrap
        
        isometrik.getIsometrik().addViewer(viewerId: userId, streamId: streamId) { streamData in
            cell.streamLoader.isHidden = true
            self.joinChannelAsViewer(rtcToken: streamData.rtcToken.unwrap, streamId: streamData.streamId.unwrap)
            DispatchQueue.main.async {
                completion(true, nil)
            }
        } failure: { error in
            
            cell.streamLoader.isHidden = true
            completion(false, nil)
            switch error{
            case .httpError(let errorCode, let errorMessage):
                
                // handle if stream is not live
                if errorCode == 403 {
                    self.hostNotOnline(streamId: streamId)
                    return
                }
                
                DispatchQueue.main.async{
                    self.view.showToast( message: "\(errorCode) \(errorMessage?.error ?? "")")
                }
            default :
                break
            }
        }
        
    }
    
    func joinChannelAsViewer(rtcToken: String, streamId: String){
        
        let isometrik = viewModel.isometrik
        let userId = isometrik.getUserSession().getUserId()
        
        viewModel.configureRTCToken(rtcToken: rtcToken)
        
        DispatchQueue.main.async {
            self.viewModel.joinChannel(channelName: streamId, userId: userId.ism_userIdUInt())
        }

    }
    
    func leaveStreamByViewer(userId: String, streamId: String, exit: Bool = true) {
        
        guard let visibleCell = fullyVisibleCells(streamCollectionView)
        else { return }
        
        let isometrik = viewModel.isometrik
        visibleCell.streamLoader.isHidden = false
        
        isometrik.getIsometrik().leaveViewer(streamId: streamId, viewerId: userId) { viewer in
            isometrik.getIsometrik().leaveChannel()
            if exit {
                self.dismissViewController()
            }
        } failure: { error in
            if exit {
                self.dismissViewController()
            }
        }
        
    }
    
}
