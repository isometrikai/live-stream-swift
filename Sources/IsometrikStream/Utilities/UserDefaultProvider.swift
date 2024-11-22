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
    static let purchaseDetails = "PURCHASE_DETAILS"
    static let receiptData = "RECEIPT_DATA"
    static let walletCoinBalance = "WALLET_COIN_BALANCE"
    static let walletMoneyBalance = "WALLET_MONEY_BALANCE"
}

public class UserDefaultsProvider: NSObject {
    
    
    public static var shared: UserDefaultsProvider = UserDefaultsProvider()
    private let defaults = UserDefaults.standard
    private var defaultProfile: String = ""
    
    public func resetStreamUserDefaults(){
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
        UserDefaults.standard.synchronize()
    }
    
    public func setIsometrikDefaultProfile(imageStringUrl: String){
        self.defaultProfile = imageStringUrl
    }
    
    public func getIsometrikDefaultProfile() -> String {
        return defaultProfile
    }
    
    // MARK: - Wallet details
    
    public func setPurchaseDetails(data: [String:Any]){
        UserDefaults.standard.setValue(data, forKey: UserDefaultsKey.purchaseDetails)
        UserDefaults.standard.synchronize()
    }
    
    public func getPurchaseDetails() -> [String:Any] {
        if let details = UserDefaults.standard.object(forKey: UserDefaultsKey.purchaseDetails) as? [String : Any] {
            return details
        }
        return [:]
    }
    
    public func setReceiptData(data: [[String: Any]]){
        UserDefaults.standard.setValue(data, forKey: UserDefaultsKey.receiptData)
        UserDefaults.standard.synchronize()
    }
    
    public class func getReceiptData() -> [[String:Any]]{
        if let data = UserDefaults.standard.value(forKey: UserDefaultsKey.receiptData) as? [[String:Any]] {
            return data
        }
        return [[:]]
    }
    
    public func setWalletBalance(data: Float64, currencyType: String){
        
        if currencyType == "COIN" {
            UserDefaults.standard.setValue(data, forKey: UserDefaultsKey.walletCoinBalance)
        } else {
            UserDefaults.standard.setValue(data, forKey: UserDefaultsKey.walletMoneyBalance)
        }
        
        UserDefaults.standard.synchronize()
    }
       
    public func getWalletBalance(currencyType: String) -> Float64 {
        
        if currencyType == "COIN", let data = UserDefaults.standard.value(forKey: UserDefaultsKey.walletCoinBalance) as? Float64 {
                return data
        } else if let data = UserDefaults.standard.value(forKey: UserDefaultsKey.walletMoneyBalance) as? Float64 {
                return data
        }
        return 0
        
    }
    
    // MARK: - Terminate
    
    public func removeUserDefaults(){
        let defaults = UserDefaults.standard
        
        // List of all keys to remove
        let keys = [
            UserDefaultsKey.ghostStreamData,
            UserDefaultsKey.purchaseDetails,
            UserDefaultsKey.receiptData,
            UserDefaultsKey.walletCoinBalance,
            UserDefaultsKey.walletMoneyBalance
        ]
        
        // Remove each key
        keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        
        // Optionally synchronize
        defaults.synchronize()
    }
    
}
