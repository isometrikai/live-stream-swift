//
//  PKOverlayView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 04/12/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import UIKit

class PKOverlayView: UIView {
    
    // MARK: - PROPERTIES
    
    let congratulationBannerView: PKCongratulationBannerView = {
        let view = PKCongratulationBannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    let punishmentBannerView: PKPunishmentBannerView = {
        let view = PKPunishmentBannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    let vsAnimatedView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Appearance.default.images.battleVsLogo
        imageView.isHidden = true
        return imageView
    }()
    
    let startPKBattleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(Appearance.default.images.pkStart, for: .normal)
        button.isHidden = true
        button.ismTapFeedBack()
        return button
    }()
    
    let hostToggleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Appearance.default.images.pkHostToggle, for: .normal)
        button.setTitle(" Make host   ", for: .normal)
        button.backgroundColor = .black.withAlphaComponent(0.5)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = Appearance.default.font.getFont(forTypo: .h8)
        button.ismTapFeedBack()
        button.isHidden = true
        return button
    }()
    
    let battleTimerView: PKBattleTimerView = {
        let view = PKBattleTimerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    
    let battleProgressView: CustomBattleProgressView = {
        let view = CustomBattleProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.backgroundColor = .black
        view.layer.cornerRadius = 7.5
        view.layer.masksToBounds = true
        return view
    }()
    
    let countDownView: CustomCountdownView = {
        let view = CustomCountdownView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    let drawStatusImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = Appearance.default.images.pkDraw
        imageView.isHidden = true
        return imageView
    }()
    
    // MARK: - MAIN
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.battleProgressView.layerData = BattleProgressData(color1: Appearance.default.colors.appCyan2, color2: Appearance.default.colors.appPink, width: 15, withDuration: 0.2)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNTIONS
    
    func setupViews(){
        backgroundColor = .clear
        
        addSubview(startPKBattleButton)
        addSubview(vsAnimatedView)
        
        addSubview(congratulationBannerView)
        addSubview(punishmentBannerView)
        
        addSubview(battleTimerView)
        addSubview(battleProgressView)
        
        addSubview(drawStatusImage)
        
        addSubview(countDownView)
        
        addSubview(hostToggleButton)
        
        countDownView.count = 4
        countDownView.numberLabel.textColor = Appearance.default.colors.appYellow2
        countDownView.numberLabel.font = Appearance.default.font.getFont(forTypo: .h1)
        countDownView.backgroundColor = .black.withAlphaComponent(0.2)
        
    }
    
    func setupConstraints(){
        countDownView.pin(to: self)
        NSLayoutConstraint.activate([
            
            congratulationBannerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            congratulationBannerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            congratulationBannerView.heightAnchor.constraint(equalToConstant: 20),
            congratulationBannerView.topAnchor.constraint(equalTo: topAnchor),
            
            punishmentBannerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            punishmentBannerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            punishmentBannerView.topAnchor.constraint(equalTo: congratulationBannerView.bottomAnchor),
            punishmentBannerView.heightAnchor.constraint(equalToConstant: 30),
            
            startPKBattleButton.widthAnchor.constraint(equalToConstant: 100),
            startPKBattleButton.heightAnchor.constraint(equalToConstant: 40),
            startPKBattleButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            startPKBattleButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32.5),
            
            vsAnimatedView.widthAnchor.constraint(equalToConstant: 50),
            vsAnimatedView.heightAnchor.constraint(equalToConstant: 50),
            vsAnimatedView.centerYAnchor.constraint(equalTo: centerYAnchor),
            vsAnimatedView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            hostToggleButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            hostToggleButton.heightAnchor.constraint(equalToConstant: 27),
            hostToggleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            battleTimerView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            battleTimerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            battleTimerView.widthAnchor.constraint(equalToConstant: 80),
            battleTimerView.heightAnchor.constraint(equalToConstant: 40),
            
            battleProgressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            battleProgressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            battleProgressView.heightAnchor.constraint(equalToConstant: 15),
            battleProgressView.topAnchor.constraint(equalTo: topAnchor, constant: 17.5),
            
            drawStatusImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            drawStatusImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            drawStatusImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            drawStatusImage.heightAnchor.constraint(equalToConstant: 150),
            
        ])
    }
    
    // MARK: - FUNCTIONS
    
    func animateVSAndStartView(){
        vsAnimatedView.isHidden = false
        vsAnimatedView.transform = .init(scaleX: 0, y: 0)
        startPKBattleButton.transform = .init(scaleX: 0, y: 0)
        UIView.animate(withDuration: 1.5, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 1 , animations: {
            self.vsAnimatedView.transform = .identity
        }, completion: { finished in
            self.startPKBattleButton.isHidden = false
            UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 1 , animations: {
                self.vsAnimatedView.transform = .init(scaleX: 0, y: 0)
                self.startPKBattleButton.transform = .identity
            }, completion: { finished in
                self.vsAnimatedView.isHidden = true
            })
        })
    }
    
    func animateVSView(){
        vsAnimatedView.isHidden = false
        vsAnimatedView.transform = .init(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.9, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 1 , animations: {
            self.vsAnimatedView.transform = .identity
        }, completion: { finished in
            UIView.animate(withDuration: 0.4, delay: 3, usingSpringWithDamping: 0.7, initialSpringVelocity: 1 , animations: {
                self.vsAnimatedView.transform = .init(scaleX: 0, y: 0)
            }, completion: { finished in
                self.vsAnimatedView.isHidden = true
            })
        })
    }
    
    func startCountDown(){
        countDownView.startTimer()
    }
    
    func playDrawStatusAnimation(){
        self.drawStatusImage.transform = .identity
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1) {
            self.drawStatusImage.transform = .init(scaleX: 1.8, y: 1.8)
        }
    }
}
