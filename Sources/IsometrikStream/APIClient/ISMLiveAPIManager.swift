//
//  ISMLiveAPIManager.swift
//  PicoAdda
//
//  Created by Rahul Sharma on 27/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import Foundation
import UIKit


public protocol ISMLiveURLConvertible{
    
    var baseURL : URL{
        get
    }
    var path : String{
        get
    }
    var method : ISMLiveHTTPMethod{
        get
    }
    var queryParams : [String: String]?{
        get
    }
    var headers :[String: String]? {
        get
    }
    
}


public struct ISMLiveAPIRequest<R> {
    
    let endPoint : ISMLiveURLConvertible
    let requestBody: R?
    
    public init(endPoint: ISMLiveURLConvertible, requestBody: R?) {
        self.endPoint = endPoint
        self.requestBody = requestBody
    }
    
}

public struct ISMLiveAPIManager {
    
    public static func sendRequest<T: Codable, R:Any>(request: ISMLiveAPIRequest<R>, showLoader : Bool = true, completion: @escaping (_ result : ISMLiveResult<T, ISMLiveAPIError>) -> Void) {
        
        if showLoader{
            DispatchQueue.main.async {
                CustomLoader.shared.startLoading()
            }
        }
        
        var urlComponents = URLComponents(url: request.endPoint.baseURL.appendingPathComponent(request.endPoint.path), resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = request.endPoint.queryParams?.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidResponse))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.endPoint.method.rawValue
        
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(ISMConfiguration.shared.userSecret, forHTTPHeaderField:"userSecret" )
        urlRequest.setValue(ISMConfiguration.shared.licenseKey, forHTTPHeaderField:"licenseKey")
        urlRequest.setValue(ISMConfiguration.shared.userToken, forHTTPHeaderField:"userToken" )
        urlRequest.setValue(ISMConfiguration.shared.authToken, forHTTPHeaderField: "authorization")
        urlRequest.setValue(ISMConfiguration.shared.appSecret, forHTTPHeaderField: "appSecret")
        urlRequest.setValue(ISMConfiguration.shared.userToken, forHTTPHeaderField: "isometrikToken")
        
        // Set headers if provided
        request.endPoint.headers?.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        if let requestBody = request.requestBody as? Codable {
            do {
                let jsonBody = try JSONEncoder().encode(requestBody)
                urlRequest.httpBody = jsonBody
            } catch {
                completion(.failure(.invalidResponse))
                CustomLoader.shared.stopLoading()
                return
            }
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                CustomLoader.shared.stopLoading()
                return
            }
            
            print("*****STATUS \(httpResponse.statusCode) ")
            
            if let error = error {
                completion(.failure(.decodingError(error)))
                return
            }
            
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                do {
                    let responseObject = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(responseObject, nil))
                } catch {
                    
                    if let decodingError = error as? DecodingError {
                        switch decodingError {
                        case .typeMismatch(let key, let context):
                            print("Type mismatch for key \(key), context: \(context.debugDescription)")
                        case .valueNotFound(let type, let context):
                            print("Value not found for type \(type), context: \(context.debugDescription)")
                        case .keyNotFound(let key, let context):
                            print("Key not found: \(key), context: \(context.debugDescription)")
                        case .dataCorrupted(let context):
                            print("Data corrupted, context: \(context.debugDescription)")
                        @unknown default:
                            print("Unknown decoding error")
                        }
                    } else {
                        print("Error: \(error.localizedDescription)")
                    }
                    
                    completion(.failure(.decodingError(error)))
                }
            case 204, 404, 400:
                completion(.failure(.noResultsFound(httpResponse.statusCode)))
            case 406 :
                break
                
                // update the headers
//                APIManager.refreshTokenAPI() { (success,token) in
//                    if success{
//                        // TODO:- Add auth token here to manage refresh token
//                        guard let authToken =  KeychainHelper.sharedInstance.keychain.get(""), let isometrikToken =   KeychainHelper.sharedInstance.keychain.get("isometrikUserToken")
//                        else{
//                            Utility.logOut()
//                            return
//                        }
//                        ISMConfiguration.shared.authToken =  authToken
//                        ISMConfiguration.shared.userToken =  isometrikToken
//                        ISMLiveAPIManager.retryRequest(request: request, completion: completion)
//                    }
//                    else{
//                        Utility.logOut()
//                    }
//                }
                
            case 401 :
                break
//                Utility.logOut()
            default:
                // Handle the error messages and statuscode
                do {
                    var errorObject = try JSONDecoder().decode(ISMLiveErrorMessage.self, from: data)
                    if let message = errorObject.message{
                        errorObject.error = message
                    }
                    completion(.failure(.httpError(httpResponse.statusCode, errorObject)))
                } catch {
                    completion(.failure(.httpError(httpResponse.statusCode, nil)))
                }
                
            }
            
            
            if showLoader{
                CustomLoader.shared.stopLoading()
            }
        }
        
        task.resume()
    }
    
  
    
    static func retryRequest<T: Codable, R:Any>(request: ISMLiveAPIRequest<R>, completion: @escaping (_ result : ISMLiveResult<T, ISMLiveAPIError>) -> Void) {
          // Add your retry logic here, such as waiting for a few seconds and then retrying
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
              ISMLiveAPIManager.sendRequest(request: request, completion: completion)
          }
      }
}


public enum ISMLiveAPIError: Error {
    case noResultsFound(Int)
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case httpError(Int,ISMLiveErrorMessage?)
}


public struct ISMLiveErrorMessage : Codable{
    public var error : String?
    public let errorCode : Int?
    public let message : String?
}

public enum ISMLiveResult<T,ErrorData>{
    case success(T,Data?)
    case failure(ErrorData)
}



