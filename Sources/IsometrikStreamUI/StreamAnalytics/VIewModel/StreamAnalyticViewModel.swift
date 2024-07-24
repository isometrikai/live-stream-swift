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
    
    var analyticData: StreamAnalyticsResponseModel?
    var viewerData: StreamAnalyticViewersResponseModel?
    var viewers: [StreamAnalyticViewers] = []
    
    var skip = 0
    var limit = 10
    
    var isometrik: IsometrikSDK
    var streamId: String
    
    var durationValue: Int64?
    var dismissCallBack: (()->Void)?
    
    init(isometrik: IsometrikSDK, streamId: String){
        self.isometrik = isometrik
        self.streamId = streamId
    }
    
    func fetchStreamAnalytics(_ completion: @escaping(Bool, String?)->Void) {

        isometrik.getIsometrik().getStreamAnalytics(streamId: streamId) { response in
            self.analyticData = response
            DispatchQueue.main.async {
                completion(true, nil)
            }
        } failure: { error in
            DispatchQueue.main.async {
                completion(false, error.localizedDescription)
            }
        }

    }
    
    func fetchStreamAnalyticsViewers(_ completion: @escaping(Bool, String?)->Void) {
        
        isometrik.getIsometrik().fetchViewersForAnalytics(streamId: streamId) { response in
            
            self.viewerData = response
            self.viewers = response.viewers ?? []
            
            if self.viewers.count.isMultiple(of: self.limit) {
                self.skip += self.limit
            }
            
            DispatchQueue.main.async {
                completion(true, nil)
            }
            
        } failure: { error in
            DispatchQueue.main.async {
                completion(false, error.localizedDescription)
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
        
        let userId = viewers[index].appUserID ?? ""
        let privacy = viewers[index].privacy ?? 0
        let followStatus = viewers[index].followStatus ?? 0
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
