//
//  ProductDefaultPlaceholderView.swift
//  Shopr
//
//  Created by new user on 30/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import Lottie

class ProductDefaultPlaceholderView: UIView, ISMStreamUIAppearanceProvider {

    // MARK: - PROPERTIES
    
    var animationHolderView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var defaultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "There are no products available to tag"
        label.font = appearance.font.getFont(forTypo: .h4)
        label.textColor = .black
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
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        addSubview(animationHolderView)
        addSubview(defaultLabel)
    }
    
    func setupConstraints(){
        
        let dimension = UIScreen.main.bounds.width * 0.6
        
        NSLayoutConstraint.activate([
            animationHolderView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationHolderView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30),
            animationHolderView.widthAnchor.constraint(equalToConstant: dimension),
            animationHolderView.heightAnchor.constraint(equalToConstant: dimension),
            
            defaultLabel.topAnchor.constraint(equalTo: animationHolderView.bottomAnchor),
            defaultLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func playAnimation(for filePath: String) {
        
        var animationView: LottieAnimationView?
        animationView = .init(filePath: filePath)
        animationView?.frame = animationHolderView.bounds
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        animationHolderView.addSubview(animationView!)
        
        animationView?.play()
        
    }

}
