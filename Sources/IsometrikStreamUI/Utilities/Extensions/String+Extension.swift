//
//  ISMString+Extension.swift
//  SOLD
//
//  Created by Dheeraj Kumar Sharma on 08/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

extension NSAttributedString {

    /// Returns a new instance of NSAttributedString with same contents and attributes with strike through added.
     /// - Parameter style: value for style you wish to assign to the text.
     /// - Returns: a new instance of NSAttributedString with given strike through.
     public func withStrikeThrough(_ style: Int = 1) -> NSAttributedString {
         let attributedString = NSMutableAttributedString(attributedString: self)
         attributedString.addAttribute(.strikethroughStyle,
                                       value: style,
                                       range: NSRange(location: 0, length: string.count))
         return NSAttributedString(attributedString: attributedString)
     }
    
}

extension String {
    
    var localized: String {
        
        return self.applyLocalizations(forLanguage: UserDefaults.standard.value(forKey: "Language") as? String ?? "" == "hi" ? "hi-IN" : "en")
    }
    
    private func applyLocalizations(forLanguage language: String = Locale.preferredLanguages.first!.components(separatedBy: "-").first!) -> String {
        guard  let basePath = Bundle.main.path(forResource: language, ofType: "lproj") , let path = Bundle(path: basePath) else {
            return self
        }
        return path.localizedString(forKey: self, value: "", table: nil)
    }
    
    func getUrlExtension() -> String {
        let fileURL = URL(string: self)
        return fileURL?.pathExtension ?? ""
    }
    
    func ism_trunc(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
    
}
