//
//  ISMUserViewModel.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 03/01/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import Foundation
import IsometrikStream

class ISMUserViewModel {
    
    var userId: String = ""
    var service: HttpUtility?
    var BaseURL = "https://api.foodieapp.net"
    var reportReasons: [String] = []
    
    init() {
        // set the auth token for web service
        let authToken = ""
        var httpUtility = HttpUtility()
        httpUtility.authToken = authToken
        self.service = httpUtility
    }
    
    func getReportReasons(_ completion: @escaping(Bool, String?)->Void){
        
        guard let service else { return }
        
        let url = "\(BaseURL)/social/v1/reportReasons"

        service.getApiData(urlString: url, resultType: ReportModel.self) { result, isometrikError in
            
            if isometrikError == nil {
                // success
                guard let result, let reportReasons = result.data else { return }
                
                self.reportReasons = reportReasons
                
                DispatchQueue.main.async {
                    completion(true, nil)
                }
                
            } else {
                // error
                DispatchQueue.main.async {
                    completion(false, "error string")
                }
            }
            
        }
        
    }
    
    func reportAUser(reason: String, _ completion: @escaping(Bool, String?)->Void){
        
        guard let service else {
            completion(false, "Service not found!")
            return
        }
        
        guard !userId.isEmpty else {
            completion(false, "User not found!")
            return
        }
        
        var requestBody: Data?
        
        let url = "\(BaseURL)/social/v1/userReportReasons"
        
        let jsonObject: [String: String] = [
            "reason": "\(reason)",
            "targetUserId": "\(self.userId)",
            "message": "\(reason)"
        ]
        
        do{
            requestBody = try? JSONEncoder().encode(jsonObject)
        } catch {
            print("ERROR")
        }
        
        service.fetchApiData(urlString: url, requestBody: requestBody, resultType: ReportModel.self, httpMethod: .POST) { result, isometrikError in
            
            if isometrikError == nil {
                // success
                guard let result else { return }
                
                let message = result.message.unwrap
                
                DispatchQueue.main.async {
                    completion(true, nil)
                }
                
            } else {
                // error
                DispatchQueue.main.async {
                    completion(false, "error string")
                }
            }
            
        }
        
    }
    
    func followUser() {
        
    }
    
}
