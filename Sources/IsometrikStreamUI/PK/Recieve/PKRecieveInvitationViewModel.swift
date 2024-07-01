//
//  PKRecieveInvitationViewModel.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 20/06/24.
//

import Foundation
import IsometrikStream

enum LinkingState {
    case request
    case linking
}

protocol PKBattleLinkingActionDelegate {
    func didLinkingStateChange(_ linkingState: LinkingState)
}

class PKRecievedInvitationViewModel: NSObject {
    
    // MARK: - PROPERTIES
    
    private(set) var isometrik: IsometrikSDK
    private(set) var streamInfo: ISMStream
    private(set) var inviteId: String
    
    var statusTitle: String = ""
    var statusDesc: String = ""
    
    var rejectTimer: Timer?
    var acceptTimer: Timer?
    var maximumRejectWait = 15.0
    var maximumAcceptWait = 10.0
    var actionDelegate: PKBattleLinkingActionDelegate?
    var isPKInvitationPending: Bool = true
    
    var response_callBack: ((_ response: PKInvitationResponse, _ streamInfo: ISM_PK_Stream?) -> ())?
    
    init(isometrik: IsometrikSDK, streamInfo: ISMStream, inviteId: String) {
        self.isometrik = isometrik
        self.streamInfo = streamInfo
        self.inviteId = inviteId
    }
    
    // MARK: - FUNTIONS
    
    func setLinkingState(_ linkingState: LinkingState) {
        
        guard let user = streamInfo.userDetails else { return }
        
        if linkingState == .request {
            statusTitle = "@\(user.userName.unwrap)" + " invite you to link".localized
            statusDesc = "You have received an invitation from".localized + " @\(user.userName.unwrap)" + " for the PK challenge. Do you want to continue?".localized
            actionDelegate?.didLinkingStateChange(.request)
        } else {
            statusTitle = "Linking".localized + "..."
            statusDesc = "PK Challenge between you and".localized + " @\(user.userName.unwrap)" + " will start soon. Please wait".localized + ".."
            actionDelegate?.didLinkingStateChange(.linking)
        }
        
    }
    
    func resetToDefault(){
        self.rejectTimer?.invalidate()
        self.acceptTimer?.invalidate()
        self.maximumRejectWait = 15
        self.maximumAcceptWait = 10
    }
    
    
}

