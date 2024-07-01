//
//  Appearance+Colors.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 27/06/24.
//

import UIKit

public struct ISM_Color {
    
    public var appColor: UIColor
    public var appSecondary: UIColor
    public var appDarkGray: UIColor
    public var appGray: UIColor
    public var appMidGray: UIColor
    public var appLighterGray: UIColor
    public var appLightGray: UIColor
    public var appRed: UIColor
    public var appGreen: UIColor
    public var appLightGreen: UIColor
    public var appPink: UIColor
    public var appCyan: UIColor
    
    public var appPurple: UIColor
    public var appDeepBlue: UIColor
    public var appLightBlue: UIColor
    
    public var appYellow: UIColor
    public var appYellow2: UIColor
    public var appLightYellow: UIColor
    public var appCyan2: UIColor
    public var appGrayBackground: UIColor
    
    public init(
        appColor: UIColor = UIColor.ism_hexStringToUIColor(hex: "#86EA5D"),
        appSecondary: UIColor = UIColor.ism_hexStringToUIColor(hex: "#163300"),
        appDarkGray: UIColor = UIColor.ism_hexStringToUIColor(hex: "#141414"),
        appGray: UIColor = UIColor.ism_hexStringToUIColor(hex: "#454745"),
        appMidGray: UIColor = UIColor.ism_hexStringToUIColor(hex: "#323234"),
        appLighterGray: UIColor = UIColor.ism_hexStringToUIColor(hex: "#e6e6e6"),
        appLightGray: UIColor = UIColor.ism_hexStringToUIColor(hex: "#F5F5F2"),
        appRed: UIColor = UIColor.ism_hexStringToUIColor(hex: "#FF3B30"),
        appGreen: UIColor = UIColor.ism_hexStringToUIColor(hex: "#0AC644"),
        appLightGreen: UIColor = UIColor.ism_hexStringToUIColor(hex: "#E6FDE3"),
        appPink: UIColor = UIColor.ism_hexStringToUIColor(hex: "#FF00E2"),
        appCyan: UIColor = UIColor.ism_hexStringToUIColor(hex: "#00EBFF"),
        appPurple: UIColor = UIColor.ism_hexStringToUIColor(hex: "#8E24AA"),
        appDeepBlue: UIColor = UIColor.ism_hexStringToUIColor(hex: "#1565C0"),
        appLightBlue: UIColor = UIColor.ism_hexStringToUIColor(hex: "#CDF6F8"),
        appYellow: UIColor = UIColor.ism_hexStringToUIColor(hex: "#D8C80E"),
        appYellow2: UIColor = UIColor.ism_hexStringToUIColor(hex: "#FFFF34"),
        appLightYellow: UIColor = UIColor.ism_hexStringToUIColor(hex: "#FCF4C6"),
        appCyan2: UIColor = UIColor.ism_hexStringToUIColor(hex: "#08BED6"), 
        appGrayBackground: UIColor = UIColor.ism_hexStringToUIColor(hex: "272727")
    ) {
        self.appColor = appColor
        self.appSecondary = appSecondary
        self.appDarkGray = appDarkGray
        self.appGray = appGray
        self.appMidGray = appMidGray
        self.appLighterGray = appLighterGray
        self.appLightGray = appLightGray
        self.appRed = appRed
        self.appGreen = appGreen
        self.appLightGreen = appLightGreen
        self.appPink = appPink
        self.appCyan = appCyan
        self.appPurple = appPurple
        self.appDeepBlue = appDeepBlue
        self.appLightBlue = appLightBlue
        self.appYellow = appYellow
        self.appYellow2 = appYellow2
        self.appLightYellow = appLightYellow
        self.appCyan2 = appCyan2
        self.appGrayBackground = appGrayBackground
    }
    
}
