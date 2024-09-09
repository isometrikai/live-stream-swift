//
//  ISMUIView+Extension.swift
//  SOLD
//
//  Created by Dheeraj Kumar Sharma on 07/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

extension UIView {
    
    public func showToast(message:String, duration : CGFloat = 3.0){
        DispatchQueue.main.async {
            ToastManager.shared.showToast(message: message, in: self)
        }
    }
    
    public func ism_pin(to superView: UIView){
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
    }
    
    func setGradient(withColors colors: [CGColor] , startPoint: CGPoint , endPoint: CGPoint) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = colors
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func ism_setGradient(withColors colors: [CGColor] , startPoint: CGPoint , endPoint: CGPoint) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = colors
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func ism_applyCoinsAnimation(indexAt: Int, fromView: UIView, coins: String, image: UIImage) {
        let bubbleImageView: UIImageView
        let size: CGSize = image.size
        
        bubbleImageView = UIImageView(image: image)
        bubbleImageView.frame = CGRect(x: self.frame.size.width - 45,
                                       y: self.frame.size.height - 20,
                                       width: size.width, height: size.height)
        self.addSubview(bubbleImageView)
        
        let zigzagPath = UIBezierPath()
        let oX: CGFloat = bubbleImageView.frame.origin.x
        let oY: CGFloat = bubbleImageView.frame.origin.y
        
        zigzagPath.move(to: CGPoint(x: oX, y: oY))
        var ey: CGFloat = 0
        var ex: CGFloat = 0
        
        switch indexAt {
        case 6:
            ex = oX + 27
            ey = oY - 56 * 2
        case 5:
            ex = oX + 20
            ey = oY - 60 * 2
        case 4:
            ex = oX + 3
            ey = oY - 80 * 2
        case 3:
            ex = oX - 34
            ey = oY - 70 * 2
        case 2:
            ex = oX - 20
            ey = oY - 100 * 2
        case 1:
            ex = oX - 3
            ey = oY - 40 * 2
        default:
            break
        }
        
        let coinsText = UILabel()
        if indexAt == 5 {
            coinsText.text = coins
            coinsText.font = UIFont.systemFont(ofSize: 0.1)
            coinsText.textColor = .yellow
            var frameForCoins: CGRect = bubbleImageView.frame
            frameForCoins.origin.x += 100
            frameForCoins.size.width = 120
            frameForCoins.size.height = 40
            coinsText.frame = frameForCoins
            self.addSubview(coinsText)
        }
        
        zigzagPath.addLine(to: CGPoint(x: ex, y: ey))
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            bubbleImageView.removeFromSuperview()
            coinsText.removeFromSuperview()
        }
        
        var animationTime = 0.5
        if indexAt == 5 {
            animationTime = 0.8
            coinsText.font = UIFont.systemFont(ofSize: 0.2)
            coinsText.alpha = 0.2
            UIView.animate(withDuration: 0.5) {
                coinsText.alpha = 1.0
                coinsText.font = UIFont.boldSystemFont(ofSize: 40)
            }
        }
        
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.duration = animationTime
        pathAnimation.path = zigzagPath.cgPath
        pathAnimation.fillMode = .forwards
        pathAnimation.isRemovedOnCompletion = false
        bubbleImageView.layer.add(pathAnimation, forKey: "movingAnimation")
        coinsText.layer.add(pathAnimation, forKey: "movingAnimation")
        CATransaction.commit()
    }

    
}

extension UIStackView {
    
    func ism_removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    public func ism_removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            ism_removeFully(view: view)
        }
    }
    
}

public extension RandomAccessCollection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    /// - complexity: O(1)
    subscript (safe index: Index) -> Element? {
        guard index >= startIndex, index < endIndex else {
            return nil
        }
        return self[index]
    }
    
}

extension UIColor {
    class func colorWithHex(color:String) -> UIColor {
        var cString:String = color.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.sorted().count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}

