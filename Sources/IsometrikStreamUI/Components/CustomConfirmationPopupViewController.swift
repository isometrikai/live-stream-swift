//
//  CustomConfirmationPopupViewController.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 08/12/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import Lottie

class CustomConfirmationPopupViewController: UIViewController, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var close_callback: (()->Void)?

    let defaultCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .black
        label.textAlignment = .center
        label.font = appearance.font.getFont(forTypo: .h5)
        return label
    }()
    
    // MARK: - MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.playAnimation(for: self.appearance.json.successAnimation)
        }
    }
    
    // MARK: - FUNCTIONS
    
    func setupView(){
        view.backgroundColor = .white
        view.addSubview(infoLabel)
        view.addSubview(defaultCoverView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            infoLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            
            defaultCoverView.bottomAnchor.constraint(equalTo: infoLabel.topAnchor, constant: -20),
            defaultCoverView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            defaultCoverView.widthAnchor.constraint(equalToConstant: 200),
            defaultCoverView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func playAnimation(for fileName: String) {
        var animationView: LottieAnimationView?
        animationView = .init(filePath: appearance.json.successAnimation)
        animationView?.frame = defaultCoverView.bounds
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        defaultCoverView.addSubview(animationView!)
        animationView?.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self else { return }
            self.dismissController()
        }
        
    }
    
    func dismissController(){
        close_callback?()
        self.dismiss(animated: true)
    }

}
