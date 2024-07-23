//
//  ISMConstants.swift
//  SOLD
//
//  Created by Dheeraj Kumar Sharma on 25/07/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

public struct ism_windowConstant {
    
    private static let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    
    public static var getTopPadding: CGFloat {
        return window?.safeAreaInsets.top ?? 0
    }
    
    public static var getBottomPadding: CGFloat {
        return window?.safeAreaInsets.bottom ?? 0
    }
    
}

enum AnyCodableValue: Codable {
    case integer(Int)
    case string(String)
    case float(Float)
    case double(Double)
    case boolean(Bool)
    case null
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        
        if let x = try? container.decode(Float.self) {
            self = .float(x)
            return
        }
        
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        
        if let x = try? container.decode(Bool.self) {
            self = .boolean(x)
            return
        }
        
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        
        if container.decodeNil() {
            self = .string("")
            return
        }
        
        throw DecodingError.typeMismatch(AnyCodableValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        case .float(let x):
            try container.encode(x)
        case .double(let x):
            try container.encode(x)
        case .boolean(let x):
            try container.encode(x)
        case .null:
            try container.encode(self)
            break
        }
    }
    
    //Get safe Values
    var stringValue: String {
        switch self {
        case .string(let s):
            return s
        case .integer(let s):
            return "\(s)"
        case .double(let s):
            return "\(s)"
        case .float(let s):
            return "\(s)"
        default:
            return ""
        }
    }
    
    var intValue: Int {
        switch self {
        case .integer(let s):
            return s
        case .string(let s):
            return (Int(s) ?? 0)
        case .float(let s):
            return Int(s)
        case .null:
            return 0
        default:
            return 0
        }
    }
    
    var floatValue: Float {
        switch self {
        case .float(let s):
            return s
        case .integer(let s):
            return Float(s)
        case .string(let s):
            return (Float(s) ?? 0)
        default:
            return 0
        }
    }
    
    var doubleValue: Double {
        switch self {
        case .double(let s):
            return s
        case .string(let s):
            return (Double(s) ?? 0.0)
        case .integer(let s):
            return (Double(s))
        case .float(let s):
            return (Double(s))
        default:
            return 0.0
        }
    }
    
    var booleanValue: Bool {
        switch self {
        case .boolean(let s):
            return s
        case .integer(let s):
            return s == 1
        case .string(let s):
            let bool = (Int(s) ?? 0) == 1
            return bool
        default:
            return false
        }
    }
}

// MARK: - ROUNDED WITH ABBREVIATIONS

public protocol RoundedWithAbbreviations {
    var ism_roundedWithAbbreviations: String { get }
}

public extension RoundedWithAbbreviations {
    var ism_roundedWithAbbreviations: String {
        let number = Int("\(self)") ?? 0
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1 {
            return "\(million)M"
        } else if thousand >= 1 {
            return "\(thousand)K"
        } else {
            return "\(number)"
        }
    }
}

extension Int: RoundedWithAbbreviations {}
extension Int64: RoundedWithAbbreviations {}

