//
//  PKInviteUserViewModel.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 30/11/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import Foundation
import UIKit
import IsometrikStream

class PKInviteUserViewModel: NSObject {
    
    var streamUserList: [ISM_PK_InviteStream] = []
    private(set) var isometrik: IsometrikSDK
    private(set) var streamInfo: ISMStream

    var linking_CallBack: ((ISM_PK_InviteStream?) ->())?
    var bottomConstraint: NSLayoutConstraint?
    
    init(isometrik: IsometrikSDK, streamInfo: ISMStream) {
        self.isometrik = isometrik
        self.streamInfo = streamInfo
    }
    
    func getData(query: String, completionHandler: @escaping () -> ()){
        isometrik.getIsometrik().getPKInviteUserList(query: query) { result in
            self.streamUserList = result.streams ?? []
            completionHandler()
        }failure: { error in
            completionHandler()
        }
    }
    
    func sendInvite(index: Int, completionHandler: @escaping (_ success: Bool,_ errorMessage : String? ) -> ()) {
        
        let userId = streamUserList[index].userId ?? ""
        let receiverStreamId = streamUserList[index].streamId ?? ""
        let senderStreamId = streamInfo.streamId ?? ""
        
        isometrik.getIsometrik().sendPKInvite(userId: userId, recieverStreamId: receiverStreamId, senderStreamId: senderStreamId) { result in
            completionHandler(true,nil)
        }failure: { error in
            switch error{
            case .noResultsFound(_):
                // handle noresults found here
                break
            case .invalidResponse:
                DispatchQueue.main.async {
                    completionHandler(false,"PK Error: Invalid Response")
                  
                }
            case .httpError(let errorCode, let errorMessage):
                DispatchQueue.main.async{
                    completionHandler(false,"PK Error:\(errorCode) \(errorMessage?.error ?? "")")
                }
            default :
                break
            }
           
        }
        
    }
    
}
