//
//  RecordedStreamViewModel.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 02/01/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import Foundation
import AVFoundation
import IsometrikStream

public class RecordedStreamViewModel {
    
    //var productViewModel: ProductViewModel
    var isometrik: IsometrikSDK
    
    //let profileViewModel = ProfileViewModel()
    //let BaseURL = "https://api.soldlive.eu"
    
    //var service: HttpUtility?
    var videoAsset: AVAsset?
    var assetUrl: URL?
    var player: AVPlayer?
    var playerState: PlayerState? = .play
    
    public var selectedIndex: IndexPath?
    var streamsData: [ISMStream]
    
    public init(isometrik: IsometrikSDK, streamsData: [ISMStream]){
        
        self.isometrik = isometrik
        self.streamsData = streamsData
        //self.productViewModel = ProductViewModel(isometrik: isometrik)
        
        // set the auth token for web service
//        guard let authToken = AppKeychain.shared.authToken else { return }
//        var httpUtility = HttpUtility()
//        httpUtility.authToken = authToken
//        self.service = httpUtility
        
    }
    
    func followUser(index: Int, _ completion: @escaping () -> Void){
        
//        guard let streamData = streamsData[safe: index], let userDetails = streamData.userDetails else { return }
//        
//        let userId = userDetails.id ?? ""
//        let privacy = userDetails.privacy ?? 0
//        let followStatus = userDetails.followStatus ?? 0
//        let isFollow = getIsFollowStatus(followStatus: followStatus)
//        
//        profileViewModel.FollowPeopleService(isFollow: !isFollow, peopleId: userId, privicy: privacy)
//        
//        // updating models after change
//        if privacy == 0 {
//            if followStatus == 0 {
//                streamsData[index].userDetails?.followStatus = 1
//            } else {
//                streamsData[index].userDetails?.followStatus = 0
//            }
//        } else {
//            if followStatus == 0 {
//                streamsData[index].userDetails?.followStatus = 2
//            } else {
//                streamsData[index].userDetails?.followStatus = 0
//            }
//        }
//        
//        completion()
        
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
    
    func viewedStream(streamId: String, _ completion: @escaping(_ success: Bool, _ errorString: String?)->Void){
        
//        guard let service
//        else { return }
//        
//        var requestBody: Data?
//        let url = "\(BaseURL)/v1/stream/recorded/view/count"
//        
//        let bodyObject: [String: String] = [
//            "id":"\(streamId)"
//        ]
//        
//        do{
//            requestBody = try? JSONEncoder().encode(bodyObject)
//            print("jsonData: ", String(data: requestBody!, encoding: .utf8) ?? "no body data")
//        } catch {
//            print("ERROR")
//        }
//        
//        service.fetchApiData(urlString: url, requestBody: requestBody, resultType: RecordCountUpdateModel.self, httpMethod: .POST) { result, isometrikError in
//            
//            if isometrikError == nil {
//                // success
//                guard let result else {
//                    completion(false, "error")
//                    return
//                }
//                DispatchQueue.main.async {
//                    completion(true, nil)
//                }
//            } else {
//                // error
//                DispatchQueue.main.async {
//                    completion(false, "error")
//                }
//            }
//            
//        }
        
    }
    
    func deleteStream(streamId: String, _ completion: @escaping(_ success: Bool, _ errorString: String?)->Void){
        
//        guard let service
//        else { return }
//        
//        var requestBody: Data?
//        let url = "\(BaseURL)/v1/stream?streamId=\(streamId)"
//        
//        service.fetchApiData(urlString: url, requestBody: requestBody, resultType: RecordCountUpdateModel.self, httpMethod: .DELETE) { result, isometrikError in
//            
//            if isometrikError == nil {
//                // success
//                guard let result else {
//                    completion(false, "error")
//                    return
//                }
//                DispatchQueue.main.async {
//                    completion(true, nil)
//                }
//                
//            } else {
//                // error
//                DispatchQueue.main.async {
//                    completion(false, "error")
//                }
//            }
//            
//        }
        
    }
    
}



