//
//  RestreamViewModel.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 12/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import Foundation
import IsometrikStream

struct RestreamTypeData {
    let staticDomainURL: String
    let image: UIImage
}

class RestreamViewModel {
    
    var isometrik: IsometrikSDK?
    var restreamChannels: [ISMRestreamChannel] = []
    var currentRestreamChannel: ISMRestreamChannel?
    
    func getRestreamChannels(_ completion: @escaping ((Bool, String?) -> Void)){

        guard let isometrik else { return }
        
        restreamChannels = [
            ISMRestreamChannel(ingestUrl: "", enabled: false, channelType: 1, channelName: "Youtube", channelId: ""),
            ISMRestreamChannel(ingestUrl: "", enabled: false, channelType: 2, channelName: "Twitch", channelId: ""),
            ISMRestreamChannel(ingestUrl: "", enabled: false, channelType: 5, channelName: "Instagram", channelId: "")
        ]
        
        self.fetchRestreamChannels { data, error in
            
            if error == nil {
                
                guard let restreamChannels = data
                else {
                    completion(false, "Unknow error")
                    return
                }
                
                
                for i in 0..<restreamChannels.count {
                    let channelData = restreamChannels[i]
                    self.updateChannelData(restreamChannelData: channelData)
                    
                    if i == restreamChannels.count - 1 {
                        completion(true, nil)
                    }
                    
                }
                
            } else {
                guard let error else { return }
                completion(false, "\(error)")
            }
            
        }
        
    }
    
    func updateChannelData(restreamChannelData: ISMRestreamChannel?){
        
        guard let restreamChannelData,
              let channelType = restreamChannelData.channelType,
              let restreamType = RestreamChannelType(rawValue: channelType)
        else { return }
        
        let ingestURL = restreamChannelData.ingestUrl ?? ""
        let channelId = restreamChannelData.channelId ?? ""
        let enabled = restreamChannelData.enabled ?? false
        
        // remove the stream channel if exist of same type and same channelId
        self.restreamChannels.removeAll { restreamChannel in
            restreamChannel.channelId == restreamChannelData.channelId || restreamChannel.channelType == restreamChannelData.channelType
        }
        
        switch restreamType {
        case .facebook:
            self.restreamChannels.append(
                ISMRestreamChannel(ingestUrl: ingestURL, enabled: enabled, channelType: channelType, channelName: "Facebook", channelId: channelId)
            )
            break
        case .youtube:
            self.restreamChannels.append(
                ISMRestreamChannel(ingestUrl: ingestURL, enabled: enabled, channelType: channelType, channelName: "Youtube", channelId: channelId)
            )
            break
        case .twitch:
            self.restreamChannels.append(
                ISMRestreamChannel(ingestUrl: ingestURL, enabled: enabled, channelType: channelType, channelName: "Twitch", channelId: channelId)
            )
            break
        case .twitter:
            self.restreamChannels.append(
                ISMRestreamChannel(ingestUrl: ingestURL, enabled: enabled, channelType: channelType, channelName: "Twitter", channelId: channelId)
            )
            
            break
        case .linkedin:
            self.restreamChannels.append(
                ISMRestreamChannel(ingestUrl: ingestURL, enabled: enabled, channelType: channelType, channelName: "LinkedIn", channelId: channelId)
            )
            break
        case .custom:
            self.restreamChannels.append(
                ISMRestreamChannel(ingestUrl: ingestURL, enabled: enabled, channelType: channelType, channelName: "Instagram", channelId: channelId)
            )
            
            break
        }
        
    }
    
    func getChannelTypeData(forRestreamType type: RestreamChannelType) -> RestreamTypeData {
        
        switch type {
        case .facebook:
            return RestreamTypeData(staticDomainURL: "", image: UIImage())
        case .youtube:
            return RestreamTypeData(staticDomainURL: "www.youtube.com/", image: ISMAppearance.default.images.youtubeLogo)
        case .twitch:
            return RestreamTypeData(staticDomainURL: "www.twitch.com/", image: ISMAppearance.default.images.twitchLogo)
        case .twitter:
            return RestreamTypeData(staticDomainURL: "", image: UIImage())
        case .linkedin:
            return RestreamTypeData(staticDomainURL: "", image: UIImage())
        case .custom:
            return RestreamTypeData(staticDomainURL: "www.instagram.com/", image: ISMAppearance.default.images.instagramLogo)
        }
        
    }
    
    func fetchRestreamChannels(_ completion: @escaping (([ISMRestreamChannel]?, String?) -> Void)){
        
        guard let isometrik else { return }
        
        isometrik.getIsometrik().fetchRestreamChannels { restreamsData in
            let restreamData = restreamsData.restreamChannels ?? []
            completion(restreamData, nil)
        } failure: { error in
            let error = "Unable to fetch restream channels"
            completion(nil, error)
        }

    }
    
    func addRestreamChannels(ingestUrl: String, enabled: Bool, channelType: RestreamChannelType, channelName: String, _ completion: @escaping ((Bool, String?) -> Void)){
        
        guard let isometrik else { return }
        
        isometrik.getIsometrik().addRestreamChannel(ingestUrl: ingestUrl, enabled: enabled, channelType: channelType, channelName: channelName) { restreamData in
            completion(true, nil)
        } failure: { error in
            completion(false, "unable to add restream channel")
        }
        
    }
    
    func deleteRestreamChannel(channelId: String, _ completion: @escaping ((Bool, String?) -> Void)) {
        
        guard let isometrik else { return }
        
        isometrik.getIsometrik().deleteRestreamingChannel(channelId: channelId) { restreamData in
            completion(true, nil)
        } failure: { error in
            completion(false, "unable to delete restream channel")
        }

    }
    
    func updateRestreamChannels(ingestUrl: String, enabled: Bool, channelName: String, channelId: String, channelType: RestreamChannelType, _ completion: @escaping ((Bool, String?) -> Void)){
        
        guard let isometrik
        else { return }
        
        isometrik.getIsometrik().updateRestreamChannel(channelId: channelId, ingestUrl: ingestUrl, enabled: enabled, channelType: channelType , channelName: channelName) { restreamData in
            completion(true, nil)
        } failure: { error in
            completion(false, "unable to update restream channel")
        }
        
    }
    
}
