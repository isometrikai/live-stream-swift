//
//  Utils.swift
//  CollectionviewTableViewIndex
//
//  Created by Rahul Sharma on 21/02/22.
//


import UIKit

struct ISM_AppConstants {
    static let userdefaultUserIdKey = "initiatorId"
    static let userdefaultUserImage = "initiatorImage"
    static let userdefaultUserIdentifier = "initiatorIdentifier"
    static let userdefaultUserName = "initiatorName"
    static let userdefaultFirstName = "firstName"
    static let userdefaultLastName = "lastName"
    static let pkBattleStatus = "pkBattleStatus"
    static let userdefaultUserToken = "userToken"
}

extension Data {
    func ism_live_decode<T:Codable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
}

public func += <K, V>(left: inout [K: V], right: [K: V]) {
    left.merge(right) { (current, _) in current }
}

// MARK: - Optional String -
extension Optional where Wrapped == Bool {
    public var unwrap: Bool {
        return self ?? false
    }
}

// MARK: - Optional String -
extension Optional where Wrapped == String {
    public var unwrap: String {
        return self ?? ""
    }
}

// MARK: - Optional Int -
extension Optional where Wrapped == Int {
    public var unwrap: Int {
        return self ?? 0
    }
}

