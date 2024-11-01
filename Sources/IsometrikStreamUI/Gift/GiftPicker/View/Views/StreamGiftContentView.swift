//
//  StreamGiftContentView.swift
//  PicoAdda
//
//  Created by Appscrip 3Embed on 11/03/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import UIKit
import SkeletonView

class StreamGiftContentView: UIView {
    
    // MARK: - PROPERTIES
    
    let headerView: StreamGiftContentHeaderView = {
        let view = StreamGiftContentHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let giftGroupHeaderView: StreamGiftContentGroupHeaderView = {
        let view = StreamGiftContentGroupHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isSkeletonable = true
        return view
    }()
    
    let giftContentItemView: StreamGiftContentItemsView = {
        let view = StreamGiftContentItemsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isSkeletonable = true
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
        addSubview(headerView)
        addSubview(giftGroupHeaderView)
        addSubview(giftContentItemView)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),
            
            giftGroupHeaderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            giftGroupHeaderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            giftGroupHeaderView.heightAnchor.constraint(equalToConstant: 75),
            giftGroupHeaderView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            giftContentItemView.leadingAnchor.constraint(equalTo: leadingAnchor),
            giftContentItemView.trailingAnchor.constraint(equalTo: trailingAnchor),
            giftContentItemView.bottomAnchor.constraint(equalTo: bottomAnchor),
            giftContentItemView.topAnchor.constraint(equalTo: giftGroupHeaderView.bottomAnchor)
            
        ])
        
    }
    
}

