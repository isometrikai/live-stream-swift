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
    var streamInfo: ISMStream?
    var isometrik: IsometrikSDK?
    
    var skip = 0
    var isSearchingUser: Bool = false
    var userList: [ISMStreamUser] = []
    var searchedUserList: [ISMStreamUser] = []
    
    var searchTimer: Timer?
    
    func getModerators(completion: @escaping() -> Void){
        guard let streamInfo = streamInfo,
              let isometrik = isometrik else { return }
    
        isometrik.getIsometrik().fetchModerators(streamId: streamInfo.streamId ?? "") { response in
            if let moderators = response.moderators {
                self.convertModeratorToUserData(moderators: moderators) {
                    completion()
                }
            }
        } failure: { error in
            print(error.localizedDescription)
        }
        
    }
    
    func convertModeratorToUserData(moderators: [Moderator], completion: @escaping()->Void){
        for i in 0..<moderators.count {
            let moderator = moderators[i]
            
            let userData = ISMStreamUser(userId: moderator.moderatorID ?? "", identifier: moderator.moderatorIdentifier ?? "", name: moderator.moderatorName ?? "", imagePath: moderator.moderatorProfilePic ?? "", isAHost: moderator.isAdmin ?? false)
            
            self.moderatorList.append(userData)
            
            if i == moderators.count - 1 {
                completion()
            }
        }
    }
    
    func getUserList(searchString: String?, completion: @escaping(ModeratorResult) -> Void) {
        isometrik?.getIsometrik().fetchUsers(skip: skip, searchTag: searchString, limit: 10, completionHandler: { user in
            if searchString != nil {
                self.searchedUserList = user.users ?? []
            } else {
                self.userList += user.users ?? []
                if self.userList.count.isMultiple(of: 10) {
                    self.skip += 10
                }
            }
            completion(.success)
        }, failure: { error in
            let error = "fetch user failure !"
            print(error)
            completion(.error(err: IsometrikError(errorMessage: "\(error)")))
        })
    }
    
}
