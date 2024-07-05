//
//  GoLiveWithHeaderView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 19/06/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

class GoLiveWithHeaderView: UIView, AppearanceProvider {
    
    // MARK: - PROPERTIES
    
    var trackViewLeadingConstriant: NSLayoutConstraint?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Go Live With"
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h3)
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "When you go live with someone, anyone who can watch their video can watch in too."
        label.textColor = .lightGray
        label.font = appearance.font.getFont(forTypo: .h8)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // Action stack view
    
    let actionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    lazy var userActionView: GoLiveWithActionView = {
        let actionView = GoLiveWithActionView()
        actionView.translatesAutoresizingMaskIntoConstraints = false
        actionView.actionImageView.image = appearance.images.rsvpdUser.withRenderingMode(.alwaysTemplate)
        actionView.actionImageView.tintColor = .white
        actionView.actionLabel.text = "User"
        return actionView
    }()
    
    lazy var viewerActionView: GoLiveWithActionView = {
        let actionView = GoLiveWithActionView()
        actionView.translatesAutoresizingMaskIntoConstraints = false
        actionView.actionImageView.image = appearance.images.eye.withRenderingMode(.alwaysTemplate)
        actionView.actionImageView.tintColor = .white
        actionView.actionLabel.text = "Viewer"
        return actionView
    }()
    
    //:
    
    let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return view
    }()
    
    let trackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    // search bar view
    
    let searchBarView: GlobalSearchBarView = {
        let view = GlobalSearchBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.searchTextField.returnKeyType = .done
        view.searchTextField.autocorrectionType = .no
        view.searchTextField.autocapitalizationType = .none
        return view
    }()
    
    //:
    
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
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        addSubview(actionStackView)
        actionStackView.addArrangedSubview(userActionView)
        actionStackView.addArrangedSubview(viewerActionView)
        
        addSubview(dividerView)
        addSubview(trackView)
        
        addSubview(searchBarView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            
            actionStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            actionStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            actionStackView.bottomAnchor.constraint(equalTo: dividerView.topAnchor),
            
            userActionView.heightAnchor.constraint(equalToConstant: 40),
            viewerActionView.heightAnchor.constraint(equalToConstant: 40),
            
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: searchBarView.topAnchor, constant: -5),
            dividerView.heightAnchor.constraint(equalToConstant: 0.7),
            
            trackView.heightAnchor.constraint(equalToConstant: 1),
            trackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            trackView.bottomAnchor.constraint(equalTo: searchBarView.topAnchor, constant: -5),
            
            searchBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBarView.heightAnchor.constraint(equalToConstant: 50),
            searchBarView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
        
        trackViewLeadingConstriant = trackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        trackViewLeadingConstriant?.isActive = true
    }
    
    func animateTrackIndicator(for selectionType: GoLiveWithSelectionType){
        if selectionType == .user {
            trackViewLeadingConstriant?.constant = 0
        } else {
            trackViewLeadingConstriant?.constant = self.frame.width / 2
        }
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
}
