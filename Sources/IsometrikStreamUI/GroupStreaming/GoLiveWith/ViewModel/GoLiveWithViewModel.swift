//
//  GoLiveWithViewModel.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 19/06/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import Foundation
import IsometrikStream

enum GoLiveWithSelectionType {
    case user
    case viewer
}

enum GoLiveWithResult {
    case success
    case failure(msg: String)
}

class GoLiveWithViewModel: NSObject {
    
    var selectedOption: GoLiveWithSelectionType? = .user
    var isometrik: IsometrikSDK?
    var viewers:[ISMViewer] = []
    var users:[ISMStreamUser] = []
    var streamData: ISMStream?
    var userPageToken: String = ""
    var viewerPageToken: String = ""
    var canServiceCall: Bool = false
    
    var isSearching: Bool = false
    var searchedUser: [ISMStreamUser] = []
    
    func getUsers(completion: @escaping(GoLiveWithResult) -> Void) {
        
        guard let isometrik = isometrik else {
            completion(.failure(msg: "Isometrik found nil!"))
            return
        }
        
//        isometrik.getIsometrik().fetchUsers(pageToken: userPageToken) { result in
//            switch result {
//            case .success(let userData):
//                if let userData = userData as? ISMUsersData {
//                    print(userData)
//                    self.users += userData.users ?? []
//                    self.userPageToken = userData.pageToken ?? ""
//                    completion(.success)
//                }
//                completion(.failure(msg: "Unknown Error"))
//
//            case .failure(let error):
//                completion(.failure(msg: "\(error.errorMessage)"))
//            }
//        }
        
    }
    
    func getViewers(completion: @escaping(GoLiveWithResult) -> Void) {
        
        guard let isometrik = isometrik,
              let streamData = streamData
        else {
            DispatchQueue.main.async {
                completion(.failure(msg: "Isometrik found nil!"))
            }
            return
        }
        
        isometrik.getIsometrik().fetchViewers(streamId: streamData.streamId ?? ""){ [self] (data) in
            self.viewers += data.viewers ?? []
            DispatchQueue.main.async {
                completion(.success)
            }
        }failure: { error in
            
            switch error{
            case .noResultsFound(_) :
                DispatchQueue.main.async {
                    completion(.failure(msg: "no result found"))
                }
                break
            case .httpError(let errorCode, let errorMessage):
                DispatchQueue.main.async {
                    completion(.failure(msg: "\(errorCode) \(errorMessage?.error ?? "")"))
                }
            default :
                break
            }
        }
    }
    
    func addMember(userId: String, completion: @escaping(GoLiveWithResult) -> Void) {
        
        guard let isometrik = isometrik,
              let streamData = streamData
        else {
            DispatchQueue.main.async {
                completion(.failure(msg: "Isometrik found nil!"))
            }
            return
        }
        
        let streamId = streamData.streamId ?? ""
        let userId = userId
        
        isometrik.getIsometrik().addMember(streamId: streamId, memberId: userId) { result in
                DispatchQueue.main.async {
                    completion(.success)
                }
        }failure: { error in
            switch error{
            case .noResultsFound(_):
                DispatchQueue.main.async {
                    completion(.failure(msg: "no result found"))
                }
                break
            case .invalidResponse:
                DispatchQueue.main.async {
                    completion(.failure(msg: "Member Error : Invalid Response"))
                }
            case .httpError(let errorCode, let errorMessage):
                DispatchQueue.main.async{
                    completion(.failure(msg: "Member Error : \(errorCode) \(errorMessage?.error ?? "")"))
                }
            default :
                break
            }
        }

    }
    
    func resetData(){
        userPageToken = ""
        users = []
        viewers = []
        selectedOption = .user
    }
    
    func getCellCount() -> Int {
        if selectedOption == .user {
            return users.count
        } else {
            return viewers.count
        }
    }
     
}
