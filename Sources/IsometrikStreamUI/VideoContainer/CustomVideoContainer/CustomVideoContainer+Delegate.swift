//
//  CustomVideoContainer+Delegate.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 31/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit
import IsometrikStream

extension CustomVideoContainer: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoSessions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoContainerCell", for: indexPath) as! VideoContainerCell
        
        cell.tag = indexPath.item
        cell.isometrik = isometrik
        
        if let streamInfo = streamInfo {
            cell.isPKStream = streamInfo.isPkChallenge.unwrap
        }
        
        if let videoSession = videoSessions[safe: indexPath.item] {
            cell.videoSession = videoSession
            cell.videoView.isHidden = false
            cell.sessionProfileView.isHidden = false
        } else {
            cell.moreOptionView.isHidden = true
            cell.sessionProfileView.isHidden = true
            cell.videoView.isHidden = true
            cell.setupRTMPDefaultView()
        }
        
        cell.delegate = self
        cell.contentView.isUserInteractionEnabled = false

        containerCellUISetup(cell: cell)
        
        return cell
    }
    
    func configureCompositionalLayout(withCells cellCount: Int) {
        
        var layout: UICollectionViewCompositionalLayout?

        layout = UICollectionViewCompositionalLayout { (sectionNumber, env) in
            VideoContainerLayout.shared.getLayout(withVideoSession: cellCount)
        }

        guard let layout = layout else { return }
        videoContainerCollectionView.collectionViewLayout = layout
        
    }
    
}

extension CustomVideoContainer: VideoContainerActionDelegate {
    
    func didMoreOptionTapped(index: Int, videoSession: VideoSession?) {
        delegate?.didMoreOptionTapped(index: index, videoSession: videoSession)
    }
    
    func didRTMPMemberViewTapped(index: Int) {
        delegate?.didRTMPMemberViewTapped(index: index)
    }
    
}
