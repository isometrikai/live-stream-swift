//
//  ModeratorViewModel.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 15/02/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import Foundation
import IsometrikStream

enum ModeratorResult {
    case success
    case error(err: IsometrikError)
}

class ModeratorViewModel: NSObject {
    
    var moderatorList: [ISMStreamUser] = []
    var streamInfo: ISMStream
    var isometrik: IsometrikSDK
    
    var skip = 0
    var limit = 10
    var isDataLoading: Bool = true
    
    var isSearchingUser: Bool = false
    var userList: [ISMStreamUser] = []
    var searchedUserList: [ISMStreamUser] = []
    
    let debouncer = Debouncer(delay: 0.5)
    var delegate: StreamModeratorsListActionDelegate?
    var change_callback: (()->Void)?
    
    init(streamInfo: ISMStream, isometrik: IsometrikSDK) {
        self.streamInfo = streamInfo
        self.isometrik = isometrik
    }
    
    func getModerators(completion: @escaping() -> Void){
    
        isometrik.getIsometrik().fetchModerators(streamId: streamInfo.streamId ?? "", skip: skip, limit: limit) { response in
            if let moderators = response.moderators {
                
                if moderators.count.isMultiple(of: self.limit) {
                    self.skip += self.limit
                }
                
                self.convertModeratorToUserData(moderators: moderators) {
                    completion()
                }
                
            }
        } failure: { error in
            print(error.localizedDescription)
        }
        
    }
    
    func convertModeratorToUserData(moderators: [Moderator], completion: @escaping()->Void){
        
        moderators.forEach { moderator in
            
            let moderatorId = moderator.moderatorID.unwrap
            let moderatorIdentifier = moderator.moderatorIdentifier.unwrap
            let moderatorName = moderator.moderatorName.unwrap
            let moderatorProfile = moderator.moderatorProfilePic.unwrap
            let isAdmin = moderator.isAdmin.unwrap
            
            let userData = ISMStreamUser(
                userId: moderatorId,
                identifier: moderatorIdentifier,
                name: moderatorName,
                imagePath: moderatorProfile,
                isAHost: isAdmin
            )
            
            self.moderatorList.append(userData)
            
            if moderator == moderators.last {
                completion()
            }
        }
        
    }
    
    func getUserList(searchString: String?, completion: @escaping(ModeratorResult) -> Void) {
        isometrik.getIsometrik().fetchUsers(skip: skip, searchTag: searchString, limit: limit, completionHandler: { user in
            if searchString != nil {
                self.searchedUserList = user.users ?? []
            } else {
                if self.userList.count.isMultiple(of: self.limit) {
                    self.skip += self.limit
                }
                self.userList.append(contentsOf: user.users ?? [])
            }
            completion(.success)
        }, failure: { error in
            let error = "Fetch user failure"
            completion(.error(err: IsometrikError(errorMessage: "\(error)")))
        })
    }
    
    func addModerator(userId: String){
        let streamInitiatorId = streamInfo.createdBy.unwrap
        let streamId = streamInfo.streamId.unwrap
        isometrik.getIsometrik().addModerator(streamId: streamId, moderatorId: userId, initiatorId: streamInitiatorId) { result in } failure: { error in }
    }
    
}
