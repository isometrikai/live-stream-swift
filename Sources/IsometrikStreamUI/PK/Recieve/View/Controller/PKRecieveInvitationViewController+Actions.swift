//
//  PKRecieveInvitationViewController+Actions.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 20/06/24.
//

import Foundation

extension PKRecieveInvitationViewController: PKBattleLinkingActionDelegate {
    
    func didLinkingStateChange(_ linkingState: LinkingState) {
        
        titleLabel.text = viewModel.statusTitle
        descriptionLabel.text = viewModel.statusDesc
        
        switch linkingState {
        case .request:
            bottomActionStack.isHidden = false
            customLoader.isHidden = true
            
            viewModel.resetToDefault()
            // start Reject timer
            viewModel.rejectTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(rejectTimerAction), userInfo: nil, repeats: true)
            
        case .linking:
            bottomActionStack.isHidden = true
            customLoader.isHidden = false
        }
    }
    
}
