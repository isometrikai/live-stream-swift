//
//  RecordingPlayerCollectionViewCell+ActionDelegate.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 29/12/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

extension RecordingPlayerCollectionViewCell: RecordedStreamOptionDelegate, RecordedStreamProductsActionDelegate, PlayerSliderActionDelegate {
    
    func didRecordedStreamOptionTapped(option: RecordedStreamOptions?) {
        delegate?.didRecordedStreamOptionTapped(option: option, index: self.tag)
    }
    
    func didProductTapped(index: Int) {
        delegate?.didProductTapped(index: index)
    }
    
    func addToCartButtonTapped(index: Int) {
        delegate?.didAddToCartButtonTapped(index: index)
    }
    
    func didScrub(_ playbackSlider:UISlider, event: UIEvent) {
        delegate?.didScrub(playbackSlider, event: event)
    }
    
}
