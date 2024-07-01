//
//  FloatingHeartView.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 10/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import Foundation
import UIKit

// MARK: HeartView
enum RotationDirection: CGFloat {
    case Left = -1
    case Right = 1
}

let PI = CGFloat(M_PI)

public class FloatingHeartView: UIView, AppearanceProvider {

    static let heartSize: CGFloat = 36
    static let burstDelay: TimeInterval = 0.1
    var heartImageView: UIImageView?
    
    private struct Durations {
        static let Full: TimeInterval = 4.0
        static let Bloom: TimeInterval = 0.5
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        heartImageView = UIImageView(frame: self.frame)
        self.addSubview(heartImageView ?? UIImageView())
        backgroundColor = UIColor.clear
        layer.anchorPoint = CGPoint(x: 0.5, y: 1)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: Animations

    public func animateInView(view: UIView, imageToUse: UIImage) {
        heartImageView?.image = imageToUse
        heartImageView?.tintColor = appearance.colors.appColor
        guard let rotationDirection = RotationDirection(rawValue: CGFloat(1 - Int(2 * randomNumber(cap: 2)))) else { return }
        prepareForAnimation()
        performBloomAnimation()
        performSlightRotationAnimation(direction: rotationDirection)
        addPathAnimation(inView: view)
    }

    private func prepareForAnimation() {
        transform = CGAffineTransform(scaleX: 0, y: 0)
        alpha = 0
    }

    private func performBloomAnimation() {
        UIView.animate(withDuration: Durations.Bloom, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [], animations: {
            self.transform = CGAffineTransform.identity
            self.alpha = 0.9
        }, completion: nil)
    }

    private func performSlightRotationAnimation(direction: RotationDirection) {
        let rotationFraction = randomNumber(cap: 10)
        UIView.animate(withDuration: Durations.Full, animations: {
            self.transform = CGAffineTransform(rotationAngle: direction.rawValue * PI / (16 + rotationFraction * 0.2))
        }, completion: nil)
    }

    private func travelPath(inView view: UIView) -> UIBezierPath? {
        guard let endPointDirection = RotationDirection(rawValue: CGFloat(1 - Int(2 * randomNumber(cap: 2)))) else { return nil }

        let heartCenterX = center.x
        let heartSize = bounds.width
        let viewHeight = view.bounds.height

        //random end point
        let endPointX = heartCenterX + (endPointDirection.rawValue * randomNumber(cap: 2 * heartSize))
        let endPointY = viewHeight / 8.0 + randomNumber(cap: viewHeight / 4.0)
        let endPoint = CGPoint(x: endPointX, y: endPointY)

        //random Control Points
        let travelDirection = CGFloat(1 - Int(2 * randomNumber(cap: 2)))
        let xDelta = (heartSize / 2.0 + randomNumber(cap: 2 * heartSize)) * travelDirection
        let yDelta = max(endPoint.y ,max(randomNumber(cap: 8 * heartSize), heartSize))
        let controlPoint1 = CGPoint(x: heartCenterX + xDelta, y: viewHeight - yDelta)
        let controlPoint2 = CGPoint(x: heartCenterX - 2 * xDelta, y: yDelta)

        let path = UIBezierPath()
        path.move(to: center)
        path.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        return path
    }

    private func addPathAnimation(inView view: UIView) {
        guard let heartTravelPath = travelPath(inView: view) else { return }
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "position")
        keyFrameAnimation.path = heartTravelPath.cgPath
        keyFrameAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        let durationAdjustment = 4 * TimeInterval(heartTravelPath.bounds.height / view.bounds.height)
        let duration = Durations.Full + durationAdjustment
        keyFrameAnimation.duration = duration
        layer.add(keyFrameAnimation, forKey: "positionOnPath")

        animateToFinalAlpha(withDuration: duration)
    }

    private func animateToFinalAlpha(withDuration duration: TimeInterval = Durations.Full) {
        FloatingHeartView.animate(withDuration: duration, delay: 0,
            animations: {
                self.alpha = 0.0
            },
            completion: {_ in
                self.removeFromSuperview()
            }
        )
    }
    
    func randomNumber(cap: Int) -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(cap)))
    }

    func randomNumber(cap: CGFloat) -> CGFloat {
        return randomNumber(cap: Int(cap))
    }
}
