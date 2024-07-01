//
//  HttpUtility.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 25/10/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import Foundation
import IsometrikStream

enum customHTTPMethod: String {
    case POST = "post"
    case GET = "get"
    case PATCH = "patch"
    case DELETE = "delete"
    case PUT = "PUT"
}

public struct HttpUtility {
    
    var authToken: String?
    var storeCategoryId: String = ""
    
    func getApiData<T: Codable>(urlString: String, resultType: T.Type, _ headers: [String: String] = [:], completionHandler: @escaping(_ result: T?, _ isometrikError: IsometrikError?) -> Void){
        
        guard let authToken, let requestURL = URL(string: urlString) else {
            let isometrikError = IsometrikError(httpResponseCode: 0, errorMessage: "Token Not Found!")
            completionHandler(nil, isometrikError)
            return
        }
        
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = "get"
        
        var headerValues = [
            "Authorization" : "\(authToken)",
            "storeCategoryId": "\(storeCategoryId)",
            "lang": "en",
            "language": "en"
//            "currencycode": Utility.getCurreny(),
//            "currencysymbol": Utility.getCurrenySymbol().toBase64()
        ]
        headerValues += headers
        urlRequest.allHTTPHeaderFields = headerValues
        
        URLSession.shared.dataTask(with: urlRequest) { (responseData, httpUrlResponse, error) in
            if (error == nil && responseData != nil && responseData?.count != 0){
                print(String(data: responseData!, encoding: .utf8)!)
                // parse the responseData here
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(T.self, from: responseData!)
                    completionHandler(result, nil)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Decoding error (keyNotFound): \(key) not found in \(context.debugDescription)")
                    print("Coding path: \(context.codingPath)")
                    
                    let error = "error"
                    let isometrikError = IsometrikError(errorMessage: error)
                    completionHandler(nil, isometrikError)
                } catch let DecodingError.dataCorrupted(context) {
                    print("Decoding error (dataCorrupted): data corrupted in \(context.debugDescription)")
                    print("Coding path: \(context.codingPath)")
                    
                    let error = "error"
                    let isometrikError = IsometrikError(errorMessage: error)
                    completionHandler(nil, isometrikError)
                } catch let DecodingError.typeMismatch(type, context) {
                    print("Decoding error (typeMismatch): type mismatch of \(type) in \(context.debugDescription)")
                    print("Coding path: \(context.codingPath)")
                    
                    let error = "error"
                    let isometrikError = IsometrikError(errorMessage: error)
                    completionHandler(nil, isometrikError)
                } catch let DecodingError.valueNotFound(type, context) {
                    print("Decoding error (valueNotFound): value not found for \(type) in \(context.debugDescription)")
                    print("Coding path: \(context.codingPath)")
                    
                    let error = "error"
                    let isometrikError = IsometrikError(errorMessage: error)
                    completionHandler(nil, isometrikError)
                } catch let error {
                    debugPrint("error occur while decoding = \(error.localizedDescription)")
                    
                    let error = "error"
                    let isometrikError = IsometrikError(errorMessage: error)
                    completionHandler(nil, isometrikError)
                }
                
            } else {
                let response = httpUrlResponse as? HTTPURLResponse
                let responseCode = response?.statusCode ?? 0
                let isometrikError = IsometrikError(httpResponseCode: responseCode, errorMessage: "No content")
                completionHandler(nil, isometrikError)
            }
        }.resume()
        
    }
    
    func fetchApiData<T: Codable>(urlString: String, requestBody: Data?, resultType: T.Type, _ headers: [String: String] = [:], httpMethod: customHTTPMethod = .POST, completionHandler: @escaping(_ result: T?, _ isometrikError: IsometrikError?) -> Void){

        guard let authToken, let requestURL = URL(string: urlString) else {
            let isometrikError = IsometrikError(httpResponseCode: 0, errorMessage: "Token Not Found!")
            completionHandler(nil, isometrikError)
            return
        }
        
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.httpBody = requestBody
        
        var headerValues: [String: String] = [:]

        if httpMethod == .PATCH {
            headerValues = [
                "Content-Type" : "application/json",
                "Authorization": "\(authToken)",
                "storeCategoryId": "\(storeCategoryId)"
            ]
        } else {
            headerValues = [:]
        }
        
        headerValues += headers
        urlRequest.allHTTPHeaderFields = headerValues
        

        URLSession.shared.dataTask(with: urlRequest) { (responseData, httpUrlResponse, error) in
            if (error == nil && responseData != nil && responseData?.count != 0){

                print(String(data: responseData!, encoding: .utf8)!)

                // parse the responseData here
                do {
                    let result = try JSONDecoder().decode(T.self, from: responseData!)

                    DispatchQueue.main.async {
                        completionHandler(result, nil)
                    }

                } catch let error {
                    let errorMessage = "error occur while decoding = \(error.localizedDescription)"
                    let isometrikError = IsometrikError(errorMessage: "\(errorMessage)")
                    completionHandler(nil, isometrikError)
                }
            }
        }.resume()

    }
    
}
