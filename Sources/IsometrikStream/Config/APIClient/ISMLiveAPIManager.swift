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
    
    public static func sendRequest<T: Decodable, R:Any>(request: ISMLiveAPIRequest<R>, completion: @escaping (_ result : ISMLiveResult<T, ISMLiveAPIError>) -> Void) {
        
        let endpoint = "\(request.endPoint.baseURL)\(request.endPoint.path)"
        let endpointMethod = "\(request.endPoint.method)".uppercased()
        ISMLogManager.shared.logNetwork("Endpoint: \(endpointMethod) \(endpoint)", type: .debug)
        
        var urlComponents = URLComponents(url: request.endPoint.baseURL.appendingPathComponent(request.endPoint.path), resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = request.endPoint.queryParams?.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidResponse))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.endPoint.method.rawValue
        
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(ISMConfiguration.shared.userSecret, forHTTPHeaderField:"userSecret")
        urlRequest.setValue(ISMConfiguration.shared.licenseKey, forHTTPHeaderField:"licenseKey")
        urlRequest.setValue(ISMConfiguration.shared.userToken, forHTTPHeaderField:"userToken" )
        urlRequest.setValue(ISMConfiguration.shared.appSecret, forHTTPHeaderField: "appSecret")
        
        // Set headers if provided
        request.endPoint.headers?.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        if let requestBody = request.requestBody as? Encodable {
            do {
                let jsonBody = try JSONEncoder().encode(requestBody)
                urlRequest.httpBody = jsonBody
            } catch {
                completion(.failure(.invalidResponse))
                return
            }
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            ISMLogManager.shared.logNetwork("HttpStatusCode: \(httpResponse.statusCode)", type: .debug)
            
            if let error = error {
                completion(.failure(.decodingError(error)))
                return
            }
            
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            switch httpResponse.statusCode {
            case 200, 201:
                do {
                    let responseObject = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(responseObject, nil))
                } catch {
                    if let decodingError = error as? DecodingError {
                        self.handleDecodingError(error: decodingError)
                    } else {
                        ISMLogManager.shared.logNetwork("Error: \(error.localizedDescription)", type: .debug)
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
                completion(.failure(.httpError(401, ISMLiveErrorMessage(errorCode: 0, message: "Unauthorize"))))
            default:
                // Handle the error messages and statuscode
                do {
                    var errorObject = try JSONDecoder().decode(ISMLiveErrorMessage.self, from: data)
                    completion(.failure(.httpError(httpResponse.statusCode, errorObject)))
                    ISMLogManager.shared.logNetwork("Error: \(errorObject.readableErrorMessage.unwrap)", type: .debug)
                } catch {
                    if let decodingError = error as? DecodingError {
                        self.handleDecodingError(error: decodingError)
                    } else {
                        ISMLogManager.shared.logNetwork("Error: \(error.localizedDescription)", type: .debug)
                    }
                    completion(.failure(.decodingError(error)))
                }
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
    
    
    static func handleDecodingError(error: DecodingError){
        switch error {
        case .typeMismatch(let key, let context):
            ISMLogManager.shared.logNetwork("Type mismatch for key \(key), context: \(context.debugDescription)", type: .debug)
        case .valueNotFound(let type, let context):
            ISMLogManager.shared.logNetwork("Value not found for type \(type), context: \(context.debugDescription)", type: .debug)
        case .keyNotFound(let key, let context):
            ISMLogManager.shared.logNetwork("Key not found: \(key), context: \(context.debugDescription)", type: .debug)
        case .dataCorrupted(let context):
            ISMLogManager.shared.logNetwork("Data corrupted, context: \(context.debugDescription)", type: .debug)
        @unknown default:
            print("")
            ISMLogManager.shared.logNetwork("Unknown decoding error", type: .debug)
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
    public var errors: [String : [String]]?
    public let errorCode : Int?
    public let message : String?
    
    
    public var readableErrorMessage: String? {
        guard let errors else {
            return error
        }
        
        var errorMessage = ""
        for (key, errorMessages) in errors {
            let combinedMessages = errorMessages.joined(separator: ", ")
            errorMessage += "\(key): \(combinedMessages)\n"
        }
        return errorMessage.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}

public enum ISMLiveResult<T,ErrorData>{
    case success(T,Data?)
    case failure(ErrorData)
}



