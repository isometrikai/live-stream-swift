//
//  StreamViewController+Hearts.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 10/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

extension StreamViewController: ISMStreamUIAppearanceProvider {
    
    func sendHeart(){
        
        guard let isometrik = viewModel.isometrik,
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        
        let streamId = streamData.streamId ?? ""
        let senderImage = isometrik.getUserSession().getUserImage()
        let senderId = isometrik.getUserSession().getUserId()
        let senderName = isometrik.getUserSession().getUserName()
        
        isometrik.getIsometrik().sendHeartMessage(streamId: streamId, senderImage: senderImage, senderIdentifier: senderName, senderId: senderId, senderName: senderName, messageType: 3, message: "") { response in
            print(response)
        } failure: { error in
            print(error)
        }
    }
    
    func playLikeAnimation(imageToUse: String) {
        
        guard let visibleCell = fullyVisibleCells(streamCollectionView)
        else { return }
        
        let maxHeartCount: Int = 1
        var visibleCount: Int = 0
        
        /// add heart view at current view.
        func heartView() {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (Double(visibleCount)/5.0)) {
                
                let heart = FloatingHeartView(frame: CGRect(x: 0, y: 0, width: FloatingHeartView.heartSize, height: FloatingHeartView.heartSize))
                
                let videoContainer = visibleCell.streamContainer.videoContainer
                videoContainer.addSubview(heart)
                
                let fountainX = videoContainer.bounds.width - ((FloatingHeartView.heartSize / 2) + 20)
                let fountainY = videoContainer.bounds.height - ((FloatingHeartView.heartSize / 2) + 8)
                
                heart.center = CGPoint(x: fountainX, y: fountainY)
                let imageToSend =  UIImage(named: imageToUse)?.withRenderingMode(.alwaysTemplate)
                heart.animateInView(view: self.view, imageToUse: (imageToSend ?? self.appearance.images.reaction))
                
            }
        }
        
        while visibleCount < maxHeartCount {
            visibleCount += 1
            heartView()
        }
    }
    
}
