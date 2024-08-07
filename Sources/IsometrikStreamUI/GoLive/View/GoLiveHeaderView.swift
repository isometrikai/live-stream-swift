//
//  NewGoLiveHeaderView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 07/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

protocol GoLiveHeaderActionDelegate {
    func didCloseButtonTapped()
    func didSelectProfileTapped()
    func didClearImageButtonTapped()
}

class GoLiveHeaderView: UIView, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var delegate: GoLiveHeaderActionDelegate?

    // HEADER VIEW
    
    let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var headerTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Go Live".localized
        label.textColor = .white
        label.textAlignment = .center
        label.font = appearance.font.getFont(forTypo: .h3)
        return label
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.close.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
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
        addSubview(headerView)
        headerView.addSubview(headerTitle)
        headerView.addSubview(closeButton)
    }
    
    func setupConstraints(){
        
        NSLayoutConstraint.activate([
            
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            headerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            
            headerTitle.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            headerTitle.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            headerTitle.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            closeButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            closeButton.widthAnchor.constraint(equalToConstant: 35),
            closeButton.heightAnchor.constraint(equalToConstant: 35),
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
        ])
        
    }
    
    // MARK: - ACTIONS
    
    @objc func closeButtonTapped(){
        delegate?.didCloseButtonTapped()
    }
    
}

extension GoLiveHeaderView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "My stream description...".localized
            textView.textColor = UIColor.lightGray
        }
    }
    
}
