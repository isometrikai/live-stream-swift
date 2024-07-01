//
//  CustomCountdownView.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 03/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

class CustomCountdownView: UIView {

    // MARK: - PROPERTIES
    
    var timer = Timer()
    var count = 4
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: Rubik.Bold, size: 100)
        label.textAlignment = .center
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
        backgroundColor = .black.withAlphaComponent(0.7)
        addSubview(numberLabel)
    }
    
    func setupConstraints(){
        numberLabel.ism_pin(to: self)
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startAnimation), userInfo: nil, repeats: true)
    }
    
    // MARK: - ACTION
    
    @objc func startAnimation(){
        self.isHidden = false
        count -= 1
        numberLabel.text = "\(count)"
        
        if count <= 0 {
            timer.invalidate()
            self.isHidden = true
            return
        }
        
        UIView.animate(withDuration:0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.numberLabel.transform = .init(scaleX: 2, y: 2)
            self.numberLabel.alpha = 1
        }, completion: {
                (value: Bool) in
            UIView.animate(withDuration: 0.3) {
                self.numberLabel.transform = .identity
                self.numberLabel.alpha = 0
            }
        })
    }

}
