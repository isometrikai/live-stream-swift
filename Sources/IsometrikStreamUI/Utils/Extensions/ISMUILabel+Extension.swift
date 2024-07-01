//
//  ISMUILabel+Extension.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 31/10/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

extension UILabel {
    
    func highlight(searchedText: String?, color: UIColor = .red) {
        guard let txtLabel = self.text?.lowercased(), let searchedText = searchedText?.lowercased() else {
            return
        }

        let attributeTxt = NSMutableAttributedString(string: txtLabel)
        let range: NSRange = attributeTxt.mutableString.range(of: searchedText, options: .caseInsensitive)

        attributeTxt.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)

        self.attributedText = attributeTxt
    }
    
    func ism_setLabelWithLeftImage(withImage image: UIImage, imageColor: UIColor, imageSize: CGFloat, text: String, font: UIFont, textColor: UIColor) {
        let attributedText = NSMutableAttributedString(string:"")
        
        let fontSize = imageSize
        let fontColor = textColor
        let font = font
        
        // Star Icon
        let starImg = image.withRenderingMode(.alwaysTemplate)
        let starImage = NSTextAttachment()
        starImage.image = starImg.withTintColor(imageColor)
        starImage.bounds = CGRect(x: 0, y: (font.capHeight - fontSize).rounded() / 2, width: fontSize, height: fontSize)
        starImage.ism_setImageHeight(height: fontSize)
        let imgString = NSAttributedString(attachment: starImage)
        attributedText.append(imgString)
        
        attributedText.append(NSAttributedString(string: " \(text)" , attributes:[NSAttributedString.Key.font: font , NSAttributedString.Key.foregroundColor: fontColor]))
        
        self.attributedText = attributedText
    }
    
}

extension NSTextAttachment {
    func ism_setImageHeight(height: CGFloat) {
        guard let image = image else { return }
        let ratio = image.size.width / image.size.height
        bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: ratio * height, height: height)
    }
}
