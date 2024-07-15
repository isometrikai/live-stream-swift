//
//  ISM_String+Extension.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 20/09/22.
//


import UIKit

extension String {
    
    public func ism_userIdUInt() -> UInt? {
        return UInt(self.prefix(8), radix: 16)
    }
    
    public func ism_heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
       let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
       return boundingBox.height
   }
    
    /// used to get width of specific text
    /// - Parameter font: set font of text
    /// - Returns: returns width required for the text
    public func ism_widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    public var ism_localized: String {
        return ""
    }
    
}

extension NSAttributedString {

    /// Returns a new instance of NSAttributedString with same contents and attributes with strike through added.
     /// - Parameter style: value for style you wish to assign to the text.
     /// - Returns: a new instance of NSAttributedString with given strike through.
     public func ism_withStrikeThrough(_ style: Int = 1) -> NSAttributedString {
         let attributedString = NSMutableAttributedString(attributedString: self)
         attributedString.addAttribute(.strikethroughStyle,
                                       value: style,
                                       range: NSRange(location: 0, length: string.count))
         return NSAttributedString(attributedString: attributedString)
     }
}

// MARK: - Optional Int64 -
extension Optional where Wrapped == Int64 {
  public var unwrap: Int64 {
    return self ?? 0
  }
}

// MARK: - Optional Double -
extension Optional where Wrapped == Double {
  public var unwrap: Double {
      return self ?? 0.0
  }
}
