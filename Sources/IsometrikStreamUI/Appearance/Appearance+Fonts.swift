//
//  Appearance+Fonts.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 27/06/24.
//

import UIKit

struct Rubik {
    static let Light = "Rubik-Light"
    static let Regular = "Rubik-Regular"
    static let Medium = "Rubik-Medium"
    static let SemiBold = "Rubik-SemiBold"
    static let Bold = "Rubik-Bold"
    static let Black  = "Rubik-Black"
}

public struct ISM_CustomFont {
    
    public var Light: String
    public var Regular: String
    public var Medium: String
    public var SemiBold: String
    public var Bold: String
    public var Black: String
    
    public init(Light: String = "Rubik-Light",
         Regular: String = "Rubik-Regular",
         Medium: String = "Rubik-Medium",
         SemiBold: String = "Rubik-SemiBold",
         Bold: String = "Rubik-Bold",
         Black: String = "Rubik-Black"
    ) {
        self.Light = Light
        self.Regular = Regular
        self.Medium = Medium
        self.SemiBold = SemiBold
        self.Bold = Bold
        self.Black = Black
    }
    
}

public struct ISM_Font {
    
    var customFont: ISM_CustomFont
    
    public init(customFont: ISM_CustomFont) {
        self.customFont = customFont
    }
    
    public func getFont(forTypo: ISM_FontTypography) -> UIFont? {
        return forTypo.uiFont
    }
    
}

public enum ISM_FontTypography {
    
    case h1
    case h2
    case h3
    case h4
    case h5
    case h6
    case h7
    case h8
    case h9
    
    public var uiFont: UIFont? {
        switch self {
        case .h1: return scaled(font: UIFont(name: Rubik.Bold, size: 40), textStyle: .title1)
        case .h2: return scaled(font: UIFont(name: Rubik.Bold, size: 24), textStyle: .title2)
        case .h3: return scaled(font: UIFont(name: Rubik.SemiBold, size: 20), textStyle: .title3)
        case .h4: return scaled(font: UIFont(name: Rubik.SemiBold, size: 16), textStyle: .headline)
        case .h5: return scaled(font: UIFont(name: Rubik.SemiBold, size: 14), textStyle: .subheadline)
        case .h6: return scaled(font: UIFont(name: Rubik.Medium, size: 14), textStyle: .body)
        case .h7: return scaled(font: UIFont(name: Rubik.Bold, size: 12), textStyle: .callout)
        case .h8: return scaled(font: UIFont(name: Rubik.Medium, size: 12), textStyle: .footnote)
        case .h9: return scaled(font: UIFont(name: Rubik.Medium, size: 10), textStyle: .footnote)
       }
    }

    private func scaled(font: UIFont?, textStyle: UIFont.TextStyle) -> UIFont {
        
        let defaultFont = UIFont.systemFont(ofSize: defaultFontSize().0, weight: defaultFontSize().1)
        let fontToUse = font ?? defaultFont
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: fontToUse)
        
    }
    
    private func defaultFontSize() -> (CGFloat, UIFont.Weight) {
        switch self {
        case .h1: return (40, .bold)
        case .h2: return (24, .bold)
        case .h3: return (20, .semibold)
        case .h4: return (16, .semibold)
        case .h5: return (14, .semibold)
        case .h6: return (14, .medium)
        case .h7: return (12, .bold)
        case .h8: return (12, .medium)
        case .h9: return (10, .regular)
        }
    }
    
}
