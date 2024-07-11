//
//  UserDefaultProvider.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 13/02/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import Foundation

public struct UserDefaultsKey {
    static let ghostStreamData = "GHOST_STREAM_DATA"
}

public class UserDefaultsProvider: NSObject {
    
    
    public static var shared: UserDefaultsProvider = UserDefaultsProvider()
    private let defaults = UserDefaults.standard
    
    public func resetUserDefaults(){
        setStreamData(model: nil)
    }
    
    // MARK: - Stream data
    
    public func setStreamData(model: ISMStream?){
        if model == nil {
            UserDefaults.standard.set(nil, forKey: UserDefaultsKey.ghostStreamData)
        } else {
            do {
                // Create JSON Encoder
                let encoder = JSONEncoder()

                // Encode Note
                let data = try encoder.encode(model)

                // Write/Set Data
                UserDefaults.standard.set(data, forKey: UserDefaultsKey.ghostStreamData)

            } catch {
                print("Unable to Encode Note (\(error))")
            }
        }
    }
    
    public func getStreamData() -> ISMStream? {
        
        // Read/Get Data
        if let data = UserDefaults.standard.data(forKey: UserDefaultsKey.ghostStreamData) {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                let streamData = try decoder.decode(ISMStream.self, from: data)
                return streamData

            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        
        return nil
        
    }
    
    public func removeStreamData() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.ghostStreamData)
    }
    
    public func getIsometrikDefaultProfile() -> String {
        return "https://cdn.getfudo.com/adminAssets/0/0/Logo.png"
    }
    
    // MARK: - Wallet details
    
    public func setPurchaseDetails(data: [String:Any]){
        UserDefaults.standard.setValue(data, forKey: "purchaseDetails")
        UserDefaults.standard.synchronize()
    }
    
    public func getPurchaseDetails() -> [String:Any] {
        if let details = UserDefaults.standard.object(forKey: "purchaseDetails") as? [String : Any] {
            return details
        }
        return [:]
    }
    
    public func setReceiptData(data: [[String: Any]]){
        UserDefaults.standard.setValue(data, forKey: "receiptData")
        UserDefaults.standard.synchronize()
    }
    
    public class func getReceiptData() -> [[String:Any]]{
        if let data = UserDefaults.standard.value(forKey: "receiptData") as? [[String:Any]] {
            return data
        }
        return [[:]]
    }
    
    public func setWalletBalance(data: Float64){
        UserDefaults.standard.setValue(data, forKey: "walletBalance")
        UserDefaults.standard.synchronize()
    }
       
    public func getWalletBalance() -> Float64 {
        if let data = UserDefaults.standard.value(forKey: "walletBalance") as? Float64 {
            return data
        }
        return 0
    }
    
}
