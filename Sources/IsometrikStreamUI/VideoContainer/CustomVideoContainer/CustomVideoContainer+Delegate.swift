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
        guard let streamInfo else { return 0 }
        if streamInfo.rtmpIngest.unwrap {
            return 5
        } else if streamInfo.isPkChallenge.unwrap {
            if videoSessions.count > 2 {
                /// Just in case video sessions goes more that 2 still show 2 in the cell, for pk case
                return 2
            } else {
                return videoSessions.count
            }
        }
        /// group stream case
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
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? VideoContainerCell {
            UIView.animate(withDuration: 0.3) {
                cell.rtmpDefaultView.transform = .init(scaleX: 0.9, y: 0.9)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? VideoContainerCell {
            UIView.animate(withDuration: 0.3) {
                cell.rtmpDefaultView.transform = .identity
            }
        }
    }
    
    func configureCompositionalLayout(withCells cellCount: Int) {
        
        guard let streamInfo else { return }
        
        var layout: UICollectionViewCompositionalLayout?

        if streamInfo.rtmpIngest.unwrap {
            layout = UICollectionViewCompositionalLayout { (sectionNumber, env) in
                VideoContainerLayout.shared.getRTMPLayout(withVideoSession: cellCount)
            }
        } else {
            layout = UICollectionViewCompositionalLayout { (sectionNumber, env) in
                VideoContainerLayout.shared.getLayout(withVideoSession: cellCount)
            }
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
