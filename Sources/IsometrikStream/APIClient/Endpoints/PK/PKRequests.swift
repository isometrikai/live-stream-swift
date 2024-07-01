//
//  PKBattleRequests.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 30/11/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import Foundation

/**
    Isometrik `PKBattle` Requests
 */

extension IsometrikStream {
    
    public func getPKInviteUserList(query: String, completionHandler: @escaping (ISM_PK_InviteUserData)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: PKRouter.inviteUserList(query: query) , requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISM_PK_InviteUserData, ISMLiveAPIError> ) in
            switch result{
            case .success(let streamResponse, _) :
                completionHandler(streamResponse)
            case .failure(let error):
                failure(error)
            }
        }
    
    }
    
    public func sendPKInvite(userId: String, recieverStreamId: String, senderStreamId: String, completionHandler: @escaping (ISM_PK_InviteUserData)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let body = SendPKInviteBody(reciverStreamId:recieverStreamId,senderStreamId: senderStreamId,userId: userId )
        let request =  ISMLiveAPIRequest(endPoint: PKRouter.inviteUser , requestBody:body)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISM_PK_InviteUserData, ISMLiveAPIError> ) in
            
            switch result{
            case .success(let streamResponse, _) :
                completionHandler(streamResponse)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    public func updateInvitationResponse(inviteId: String, streamId: String, response: PKInvitationResponse, completionHandler: @escaping (ISM_PK_InvitationRepsonse)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let body = UpdateInvitationResponseBody(inviteId:inviteId,streamId: streamId,response: response.rawValue )
        let request =  ISMLiveAPIRequest(endPoint: PKRouter.updateInvitationStatus , requestBody:body)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISM_PK_InvitationRepsonse, ISMLiveAPIError> ) in
            
            switch result{
            case .success(let streamResponse, _) :
                completionHandler(streamResponse)
            case .failure(let error):
                failure(error)
            }
        }
    
    }
    
    public func startPkChallenge(inviteId: String, timeInMin: Int,  completionHandler: @escaping (ISM_PK_InviteUserData)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
    
        let body = StartPkChallengeBody(battleTimeInMin:timeInMin , inviteId: inviteId)
   
        let request =  ISMLiveAPIRequest(endPoint: PKRouter.startPkChallenge , requestBody:body)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISM_PK_InviteUserData, ISMLiveAPIError> ) in
            
            switch result{

            case .success(let streamResponse, _) :
                completionHandler(streamResponse)
            case .failure(let error):
                failure(error)
            }
        }

    }
    
    public func stopPKChallenge(pkId: String, action: String = "FORCE_STOP",completionHandler: @escaping (ISM_PK_InviteUserData)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let body = StopPKBody(action:action , pkId: pkId)
   
        let request =  ISMLiveAPIRequest(endPoint: PKRouter.stopPK , requestBody:body)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISM_PK_InviteUserData, ISMLiveAPIError> ) in
            
            switch result{

            case .success(let streamResponse, _) :
                completionHandler(streamResponse)
            case .failure(let error):
                failure(error)
            }
        }


    }
    
    public func endPKLinking(inviteId: String, action: String = "END", intentToStop: Bool = false,completionHandler: @escaping (ISM_PK_InviteUserData)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let body = EndPKBody(action:action , InviteId: inviteId, intentToStop: intentToStop)
   
        let request =  ISMLiveAPIRequest(endPoint: PKRouter.endPK , requestBody:body)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISM_PK_InviteUserData, ISMLiveAPIError> ) in
            
            switch result{

            case .success(let streamResponse, _) :
                completionHandler(streamResponse)
            case .failure(let error):
                failure(error)
            }
        }

    }
    

    
    public func getStreamStats(streamId: String,completionHandler: @escaping (ISM_PK_StreamStatsData)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: PKRouter.getPkStreamStats(streamId:streamId) , requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISM_PK_StreamStatsData, ISMLiveAPIError> ) in
            
            switch result{

            case .success(let streamResponse, _) :
                completionHandler(streamResponse)
            case .failure(let error):
                failure(error)
            }
        }
    
    }
    
    public func sendCoinsToPK(data: SendCoinsInPKBody, completionHandler: @escaping (ISM_PK_StreamStatsData)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request =  ISMLiveAPIRequest(endPoint: PKRouter.sendCoinInPk , requestBody:data)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISM_PK_StreamStatsData, ISMLiveAPIError> ) in
            
            switch result{

            case .success(let streamResponse, _) :
                completionHandler(streamResponse)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    public func getPKBattleWinners(pkId: String,completionHandler: @escaping (ISM_PK_WinnerData)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: PKRouter.getPKWinners(pkId:pkId ) , requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISM_PK_WinnerData, ISMLiveAPIError> ) in
            
            switch result{

            case .success(let streamResponse, _) :
                completionHandler(streamResponse)
            case .failure(let error):
                failure(error)
            }
        }
    
    }
    
}
