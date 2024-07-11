//
//  Appearance.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 27/06/24.
//

import UIKit

public struct Appearance {
    
    public var images = ISM_Image()
    public var colors = ISM_Color()
    public var font = ISM_Font(customFont: ISM_CustomFont())
    public var sounds = ISM_Sound()
    public var json = ISM_JSON()

    /// Provider for custom localization which is dependent on App Bundle.
//    public var localizationProvider: (_ key: String, _ table: String) -> String = { key, table in
//        Bundle.ismSwiftCall.localizedString(forKey: key, value: nil, table: table)
//    }

    public init() {}
}

// MARK: - Appearance + Default

public extension Appearance {
    static var `default`: Appearance = .init()
}
