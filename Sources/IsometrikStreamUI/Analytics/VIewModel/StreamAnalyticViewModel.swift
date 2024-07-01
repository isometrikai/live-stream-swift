//
//  StreamAnalyticViewModel.swift
//  Yelo
//
//  Created by Nikunj M1 on 12/09/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import Foundation
import IsometrikStream

class StreamAnalyticViewModel {
    
    var service: HttpUtility?
    
    var analyticData: StreamAnalyticModel?
    var streamViewers: [StreamAnalyticViewers] = []
    var streamId = ""
    var isometrik: IsometrikSDK?
    //let profileViewModel = ProfileViewModel()
    var baseURL = "https://api.foodieapp.net/v1"
    
    
    init(){
        // set the auth token for web service
        let authToken = ""
        var httpUtility = HttpUtility()
        httpUtility.authToken = authToken
        self.service = httpUtility
    }
    
    func fetchStreamAnalytics(_ completion: @escaping(Bool, String?)->Void) {
        
        guard let service,
              streamId != ""
        else { return }
        
        let url = "\(baseURL)/stream/analytics?streamId=\(streamId)"

        service.getApiData(urlString: url, resultType: StreamAnalyticModel.self) { result, isometrikError in
            
            if isometrikError == nil {
                // success
                guard let result else { return }
                
                self.analyticData = result
                
                DispatchQueue.main.async {
                    completion(true, nil)
                }
                
            } else {
                // error
                DispatchQueue.main.async {
                    completion(false, "error string")
                }
            }
            
        }
        
    }
    
    func fetchStreamAnalyticsViewers(_ completion: @escaping(Bool, String?)->Void) {
        
        guard let service,
              streamId != ""
        else { return }
        
        let url = "\(baseURL)/analytics/stream/viewers?streamId=\(streamId)"
        
        service.getApiData(urlString: url, resultType: StreamAnalyticViewersData.self) { result, isometrikError in
            
            if isometrikError == nil {
                // success
                guard let result else { return }
                
                self.streamViewers = result.viewers ?? []
                
                DispatchQueue.main.async {
                    completion(true, nil)
                }
                
            } else {
                // error
                DispatchQueue.main.async {
                    completion(false, "error string")
                }
            }
            
        }
        
    }
    
    func getDuration(seconds: Int) -> String {
        let (hours,minutes,seconds) = seconds.ism_secondsToHoursMinutesSeconds()
        
        if hours != 0{
            return "\(hours):\(minutes):\(seconds)"
        }else{
            return "\(minutes):\(seconds)"
        }
    }
    
    func followUser(index: Int, _ completion: @escaping () -> Void){
        
        let userId = streamViewers[index].appUserID ?? ""
        let privacy = streamViewers[index].privacy ?? 0
        let followStatus = streamViewers[index].followStatus ?? 0
        let isFollow = getIsFollowStatus(followStatus: followStatus)
        
//        profileViewModel.FollowPeopleService(isFollow: !isFollow, peopleId: userId, privicy: privacy)
//        
//        // updating models after change
//        if privacy == 0 {
//            if followStatus == 0 {
//                streamViewers[index].followStatus = 1
//            } else {
//                streamViewers[index].followStatus = 0
//            }
//        } else {
//            if followStatus == 0 {
//                streamViewers[index].followStatus = 2
//            } else {
//                streamViewers[index].followStatus = 0
//            }
//        }
        
        completion()
        
    }
    
    func getIsFollowStatus(followStatus: Int) -> Bool {
//        let followStatusEnum = FollowStatusCode(rawValue: followStatus)
//        
//        switch followStatusEnum {
//        case .follow, .requested:
//            return false
//        case .following:
//            return true
//        case nil:
//            return false
//        }
        return false
    }
    
}
