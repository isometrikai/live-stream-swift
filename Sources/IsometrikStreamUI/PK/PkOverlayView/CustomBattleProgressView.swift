//
//  CustomBattleProgressView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 21/12/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import UIKit

struct BattleProgressData {
    var color1: UIColor
    var color2: UIColor
    var width: CGFloat
    var withDuration: CGFloat
}

class CustomBattleProgressView: UIView, AppearanceProvider {
    
    // MARK: - PROPERTIES
    
    let trackLayer = CAShapeLayer()
    
    var duration: CGFloat = 1
    var layerData: BattleProgressData? {
        didSet {
            guard let layerData = layerData else { return }
            setUpLayers(lineWidth: layerData.width, withColor1: layerData.color1, withColor2: layerData.color2)
            self.duration = layerData.withDuration
        }
    }
    
    let timerBarView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        return v
    }()
    
    lazy var label1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .left
        label.font = appearance.font.getFont(forTypo: .h8)
        return label
    }()
    
    lazy var label2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .right
        label.font = appearance.font.getFont(forTypo: .h8)
        return label
    }()
    
    // MARK: - MAIN
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNTIONS
    
    func setupViews(){
        addSubview(timerBarView)
        addSubview(label1)
        addSubview(label2)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            timerBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            timerBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            timerBarView.bottomAnchor.constraint(equalTo: bottomAnchor),
            timerBarView.topAnchor.constraint(equalTo: topAnchor),
            
            label1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7),
            label1.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            label2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7),
            label2.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setUpLayers(lineWidth width: CGFloat, withColor1: UIColor, withColor2: UIColor) {
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: 0))
        linePath.addLine(to: CGPoint(x: UIScreen.main.bounds.width - 140, y: 0))
        
        let line = CAShapeLayer()
        line.path = linePath.cgPath
        line.opacity = 1.0
        line.lineWidth = width
        line.strokeColor = withColor1.cgColor
        line.position = CGPoint(x: 0, y: 7.5)
        timerBarView.layer.addSublayer(line)
        
        trackLayer.path = linePath.cgPath
        trackLayer.opacity = 1.0
        trackLayer.lineWidth = width
        trackLayer.strokeColor = withColor2.cgColor
        trackLayer.strokeEnd = 0
        
        trackLayer.position = CGPoint(x: 0, y: 7.5)
        timerBarView.layer.addSublayer(trackLayer)
    }
    
    func startAnimationLayer(from: Double, to: Double){
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = from
        animation.duration = duration
        animation.toValue = to
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        trackLayer.add(animation, forKey: "strokeAnimation")
    }
    
}

