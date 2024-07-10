//
//  VideoContainerCell+Actions.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 24/06/24.
//

import UIKit
import IsometrikStream

extension VideoContainerCell {
    
    @objc func rtmpActionButtonTapped(){
        delegate?.didRTMPMemberViewTapped(index: self.tag)
    }
    
    @objc func moreOptionTapped(){
        delegate?.didMoreOptionTapped(index: self.tag, videoSession: videoSession)
    }
    
}
