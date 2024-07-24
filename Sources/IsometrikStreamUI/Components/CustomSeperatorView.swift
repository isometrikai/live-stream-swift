//
//  CustomSeperator.swift
//  Yelo
//
//  Created by Nikunj M1 on 05/09/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

class CustomSeperatorView : UIView, ISMAppearanceProvider {
    
    // MARK: - Properties
    
    lazy var seperatorView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = appearance.colors.appGrayBackground
        return v
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
    
    func setupViews(){
        addSubview(seperatorView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            seperatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            seperatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            seperatorView.heightAnchor.constraint(equalToConstant: 1),
            seperatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
}
