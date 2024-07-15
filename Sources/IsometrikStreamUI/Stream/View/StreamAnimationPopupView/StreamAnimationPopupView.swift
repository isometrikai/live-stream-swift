//
//  StreamAnimationPopupView.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 07/03/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import UIKit
import Lottie
import AVFoundation
import Kingfisher
import IsometrikStream

class StreamAnimationPopupView: UIView, ISMStreamUIAppearanceProvider {

    // MARK: - PROPERTIES
    
    var player: AVAudioPlayer?
    
    let confettiAnimationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    let defaultProfile: CustomDefaultProfileView = {
        let view = CustomDefaultProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        return view
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = appearance.font.getFont(forTypo: .h5)
        return label
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
        self.isHidden = true
        self.alpha = 0
        backgroundColor = .black.withAlphaComponent(0.7)
        addSubview(confettiAnimationView)
        addSubview(profileImage)
        addSubview(defaultProfile)
        addSubview(infoLabel)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            confettiAnimationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            confettiAnimationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            confettiAnimationView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            confettiAnimationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            profileImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            profileImage.widthAnchor.constraint(equalToConstant: 50),
            profileImage.heightAnchor.constraint(equalToConstant: 50),
            
            defaultProfile.centerXAnchor.constraint(equalTo: centerXAnchor),
            defaultProfile.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            defaultProfile.widthAnchor.constraint(equalToConstant: 50),
            defaultProfile.heightAnchor.constraint(equalToConstant: 50),
            
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            infoLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 15)
        ])
    }
    
    func playAnimation(message: ISMComment?){
        
        guard let message else { return }
        
        self.isHidden = false
        UIView.animate(withDuration: 0.4) {
            self.alpha = 1
        }
        
        self.resetViews()
        
        let profileUrlString = message.senderImage ?? ""
        let senderName = message.senderName ?? ""
        let textMessage = message.message ?? ""
        
        if profileUrlString != UserDefaultsProvider.shared.getIsometrikDefaultProfile() {
            if let profileUrl = URL(string: profileUrlString) {
                profileImage.kf.setImage(with: profileUrl)
            } else {
                profileImage.image = UIImage()
            }
        } else {
            profileImage.image = UIImage()
        }
        
        let initialText = "\(senderName.prefix(2))"
        defaultProfile.initialsText.font = appearance.font.getFont(forTypo: .h6)
        defaultProfile.initialsText.text = "\(initialText)".uppercased()
        
        infoLabel.text = "\(textMessage)"
        
        // play confetti animation
        var animationView: LottieAnimationView?
        animationView = .init(filePath: appearance.json.successAnimation)
        animationView?.frame = confettiAnimationView.bounds
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        animationView?.animationSpeed = 0.4
        confettiAnimationView.addSubview(animationView!)
        animationView?.play()
        
        self.playSound()
        
    }
    
    func playSound() {
        
        let successChimePath = appearance.sounds.successChime
        guard let url = URL(string: successChimePath) else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func resetViews(){
        
        player = nil
        // remove all subviews from confettiAnimationView
        confettiAnimationView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        profileImage.image = UIImage()
        defaultProfile.initialsText.text = ""
        infoLabel.text = ""
        
    }
    
    func stopAnimation(){
        resetViews()
        UIView.animate(withDuration: 0.4) {
            self.alpha = 0
        } completion: { finished in
            self.isHidden = true
        }
    }

}
