//
//  StreamPreviewVideoView.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 06/02/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import UIKit

class StreamPreviewVideoView: UIView {

    // MARK: - PROPERTIES
    
    let playerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    
    // MARK: MAIN -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        addSubview(playerView)
    }
    
    func setUpConstraints(){
        playerView.ism_pin(to: self)
    }

}
