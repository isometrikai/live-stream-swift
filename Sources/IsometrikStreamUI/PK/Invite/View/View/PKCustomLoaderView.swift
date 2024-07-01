//
//  PKCustomLoaderView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 02/12/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import UIKit

class PKCustomLoaderView: UIView, AppearanceProvider {

    // MARK:- PROPERTIES
    
    lazy var outerBar:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = appearance.colors.appColor.withAlphaComponent(0.2)
        view.clipsToBounds = true
        return view
    }()
    
    lazy var innerBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = appearance.colors.appColor
        return view
    }()
    
    // MARK:- MAIN
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- FUNCTIONS
 
    func setUpViews(){
        addSubview(outerBar)
        outerBar.addSubview(innerBar)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            outerBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            outerBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            outerBar.heightAnchor.constraint(equalToConstant: 3),
            outerBar.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            innerBar.leadingAnchor.constraint(equalTo: outerBar.leadingAnchor, constant: -((UIScreen.main.bounds.width - 36) * 0.25)),
            innerBar.heightAnchor.constraint(equalToConstant: 3),
            innerBar.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 36) * 0.25)
            
        ])
    }
    
    func startAnimatingLoader(){
        UIView.animate(withDuration: 1, delay: 0.5, options: [.curveEaseInOut , .repeat]) { [self] in
            innerBar.frame.origin.x += (UIScreen.main.bounds.width - 36) * 1.25
        }
    }
    
    func stopAnimatingLoader(){
        innerBar.layer.removeAllAnimations()
    }
    
}
