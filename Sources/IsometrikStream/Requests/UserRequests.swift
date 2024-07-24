//
//  UserRequests.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 12/11/22.
//

import Foundation

/**
    Isometrik `Users` Requests
 */

extension IsometrikStream {
    
    /// Fetch user list.
    /// - Parameter completionHandler: completionHandler for response data.
    public func fetchUsers(skip: Int, searchTag: String? = nil, limit: Int = 10 , completionHandler: @escaping (ISMUsersData)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
    
        let request =  ISMLiveAPIRequest<Any>(endPoint: ISMLiveUserRouter.fetchUsers(skip: skip, searchTag: searchTag, limit: limit),requestBody: nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMUsersData, ISMLiveAPIError> ) in
            
            switch result{
                
            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)
                
            }
        }
    }
    
    /// Fetch  user with id .
    /// - Parameters:
    ///   - userId: Need to fetch the details for user, Type should be **String**.
    ///   - completionHandler: completionHandler for response data.
    public func fetchUser(completionHandler: @escaping (ISMStreamUser)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: ISMLiveUserRouter.userDetails,requestBody: nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMStreamUser, ISMLiveAPIError> ) in
            
            switch result{
                
            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)
                
            }
        }
    }
    
    /// Create new user.
    /// - Parameters:
    ///   - userName: Name of user, with first name & last Name, Type should be **String**.
    ///   - contactDetails: User Id can be email or mobile number, Type should be **String**.
    ///   - imagePath: User profile image. Type should be **UIImage**.
    ///   - completionHandler: completionHandler for response data.
    public func createUser(userName: String, userIdentifier: String, userImagePath: String, password: String, completionHandler: @escaping (ISMStreamUser)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request =  ISMLiveAPIRequest(endPoint: ISMLiveUserRouter.authenticateUser, requestBody:UserBody(userName: userName,userIdentifier: userIdentifier,imagePath: userImagePath,password: password ))
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMStreamUser, ISMLiveAPIError> ) in
            
            switch result{
                
            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)
                
            }
        }
        
    }
    
    /// Update exiting user data.
    /// - Parameters:
    ///   - userName: Name of user, with first name & last Name, Type should be **String**.
    ///   - userId: Unique user Id, Type should be **String**.
    ///   - contactDetails: Contact details for user (email/Mobile), Which need to update, Type should be **String**.
    ///   - imagePath: User profile image. Type should be **UIImage**.
    ///   - completionHandler: completionHandler for response data.
    public func updateUser(userName: String, userIdentifier: String, userImagePath: String, completionHandler: @escaping (ISMStreamUser)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        let request =  ISMLiveAPIRequest(endPoint: ISMLiveUserRouter.authenticateUser, requestBody:UserBody(userName: userName,userIdentifier: userIdentifier,imagePath: userImagePath ))
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMStreamUser, ISMLiveAPIError> ) in
            
            switch result{
                
            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)
                
            }
        }
     
        
    }
    
    /// Delete exiting user data.
    /// - Parameters:
    ///   - userId: Need to delete user data , Type should be **String**.
    ///   - completionHandler: completionHandler for response data.
    public func deleteUser(completionHandler: @escaping (ISMStreamUser)->(), failure : @escaping (ISMLiveAPIError) -> ()) {

        let request =  ISMLiveAPIRequest<Any>(endPoint: ISMLiveUserRouter.deleteUser, requestBody:nil)
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMStreamUser, ISMLiveAPIError> ) in
            
            switch result{
                
            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)
                
            }
        }
    }
    
    public func authenticateUser(userIdentifier: String, password: String, completionHandler: @escaping (ISMStreamUser)->(), failure : @escaping (ISMLiveAPIError) -> ()) {
        
        
        let request =  ISMLiveAPIRequest(endPoint: ISMLiveUserRouter.authenticateUser, requestBody:UserBody(userIdentifier:userIdentifier,password: password ))
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ISMStreamUser, ISMLiveAPIError> ) in
            
            switch result{
                
            case .success(let streamResponse, _) :
                DispatchQueue.main.async {
                    completionHandler(streamResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
                print(error.localizedDescription)
                
            }
        }
    
        
    }
    
}
