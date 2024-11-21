//
//  StreamProfileBottomActionViewForViewers.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 16/03/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

public class StreamProfileBottomActionViewForViewers: UIView, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    public let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 15
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    public lazy var followAndLeaveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h5)
        button.backgroundColor = .black
        button.setTitle("Follow & Leave", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.layer.cornerRadius = 25
        button.ismTapFeedBack()
        button.isHidden = true
        return button
    }()
    
    public lazy var leaveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h5)
        button.backgroundColor = appearance.colors.appColor
        button.layer.borderColor = UIColor.colorWithHex(color: "BCBCE5").cgColor
        button.layer.borderWidth = 1
        button.setTitle("Leave", for: .normal)
        button.setTitleColor(appearance.colors.appSecondary, for: .normal)
        
        button.layer.cornerRadius = 25
        button.ismTapFeedBack()
        return button
    }()
    
    
    // MARK: - MAIN
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(leaveButton)
        buttonStackView.addArrangedSubview(followAndLeaveButton)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            buttonStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            leaveButton.heightAnchor.constraint(equalToConstant: 50),
            followAndLeaveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    public func removeViewFromStackView(view: UIView){
        buttonStackView.removeArrangedSubview(view)
        view.isHidden = true
    }
    
    public func addViewToStackView(view: UIView) {
        view.isHidden = false
        buttonStackView.addArrangedSubview(view)
    }
    
}
