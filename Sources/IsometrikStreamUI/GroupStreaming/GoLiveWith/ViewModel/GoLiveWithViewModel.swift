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

class GoLiveWithViewModel {
    
    var isometrik: IsometrikSDK
    var streamData: ISMStream
    
    var skip = 0
    var limit = 20
    
    var selectedOption: GoLiveWithSelectionType? = .user
    var viewers:[ISMViewer] = []
    
    var isSearching: Bool = false
    var users: [ISMMember] = []
    var searchedUser: [ISMMember] = []
    
    let debouncer = Debouncer(delay: 0.5)
    
    init(isometrik: IsometrikSDK, streamData: ISMStream) {
        self.isometrik = isometrik
        self.streamData = streamData
    }
    
    func getUsers(searchString: String?, completion: @escaping(GoLiveWithResult) -> Void) {
        
        let streamId = streamData.streamId.unwrap
        
        isometrik.getIsometrik().fetchEligibleMembers(streamId: streamId, searchString: searchString) { response in
            if searchString != nil {
                self.searchedUser = response
            } else {
                if self.users.count.isMultiple(of: self.limit) {
                    self.skip += self.limit
                }
                self.users.append(contentsOf: response)
            }
            completion(.success)
        } failure: { error in
            let error = "Fetch user failure"
            completion(.failure(msg: error))
        }
        
    }
    
    func getViewers(completion: @escaping(GoLiveWithResult) -> Void) {
        
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
        
        let streamId = streamData.streamId ?? ""
        let userId = userId
        
        isometrik.getIsometrik().addMember(streamId: streamId, memberId: userId) { result in
                DispatchQueue.main.async {
                    completion(.success)
                }
        } failure: { error in
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
        users = []
        viewers = []
        selectedOption = .user
        searchedUser = []
    }
    
    func getCellCount() -> Int {
        if selectedOption == .user {
            if isSearching {
                return searchedUser.count
            } else {
                return users.count
            }
        } else {
            return viewers.count
        }
    }
     
}
