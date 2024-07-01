//
//  PKSendInvitationViewModel.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 20/06/24.
//

import Foundation
import IsometrikStream

class PKSendInvitationViewModel {
    
    private(set) var streamInfo: ISM_PK_InviteStream
    
    var requestTimer: Timer?
    var maximumWait = 15
    
    var userName: String = ""
    var name: String = ""
    var profilePic: String = ""
    
    init(streamInfo: ISM_PK_InviteStream) {
        self.streamInfo = streamInfo
        self.setData()
    }
    
    func setData(){
        userName = "@\(streamInfo.userName ?? "")"
        name = "\(streamInfo.userMetaData?.firstName ?? "") \(streamInfo.userMetaData?.lastName ?? "")"
        profilePic = streamInfo.profilePic ?? ""
    }
    
}
