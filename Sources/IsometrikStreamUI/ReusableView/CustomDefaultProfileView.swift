//
//  CustomDefaultProfileView.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 31/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

final public class CustomDefaultProfileView: UIView, AppearanceProvider {

    // MARK: - PROPERTIES
    
    public lazy var initialsText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = appearance.font.getFont(forTypo: .h8)
        label.textColor = appearance.colors.appColor
        label.text = "--"
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
        translatesAutoresizingMaskIntoConstraints = false
        layer.masksToBounds = true
        backgroundColor = appearance.colors.appSecondary
        addSubview(initialsText)
    }
    
    func setupConstraints(){
        initialsText.ism_pin(to: self)
    }

}

