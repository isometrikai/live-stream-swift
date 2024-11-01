//
//  CustomSquircleView.swift
//  IsometrikStream
//
//  Created by Appscrip 3Embed on 01/11/24.
//

import UIKit

class CustomSquircleView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        let squirclePath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.width / 2.5)
        let maskLayer = CAShapeLayer()
        maskLayer.path = squirclePath.cgPath
        self.layer.mask = maskLayer
    }
}
