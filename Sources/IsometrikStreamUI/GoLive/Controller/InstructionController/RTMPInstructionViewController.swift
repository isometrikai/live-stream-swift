//
//  RTMPInstructionViewController.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 08/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

class RTMPInstructionViewController: UIViewController, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white.withAlphaComponent(0.3)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Instructions".localized
        label.textColor = .white
        label.textAlignment = .center
        label.font = appearance.font.getFont(forTypo: .h4)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You can go live again by disable the PERSISTENT RTMP Stream Key, and then go live and after this you need to stop the stream and then again start a new stream , and this time around you need to ENABLE the option for PERSISTENT RTMP URL , this will then generate a new persistent STREAM KEY that you can use on your streaming device".localized + "."
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h8)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        view.backgroundColor = UIColor.ism_hexStringToUIColor(hex: "#272727")
        
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(dividerView)
        
        view.addSubview(descriptionLabel)
    }
    
    func setupConstraints(){
        titleLabel.ism_pin(to: headerView)
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 55),
            
            dividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            dividerView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            descriptionLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
    }

}
