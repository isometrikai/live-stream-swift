//
//  StreamOptionsView.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 08/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

enum StreamOption: Int {
    case highlight = 1
    case share
    case bidder
    case store
    case camera
    case microphone
    case loved
    case speaker
    case more
    case wallet
    case analytics
    case settings
    case request
    case requestList
    case pkInvite
    case stopPKBattle
    case endPKInvite
    case gift
}

protocol StreamOptionActionDelegate {
    func didOptionsTapped(with option: StreamOption.RawValue)
}

class StreamOptionsView: UIView {

    // MARK: - PROPERTIES
    
    var delegate: StreamOptionActionDelegate?
    
    let optionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var highlightView: CustomStreamOptionView = {
        let view = CustomStreamOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundView.backgroundColor = Appearance.default.colors.appColor
        view.optionImageView.image = Appearance.default.images.diamond.withRenderingMode(.alwaysTemplate)
        view.optionImageView.tintColor = .black
        view.optionButton.addTarget(self, action: #selector(optionTappedWithTag(_:)), for: .touchUpInside)
        view.layer.cornerRadius = 22.5
        view.optionButton.tag = StreamOption.highlight.rawValue
        view.isHidden = true
        return view
    }()
    
    lazy var shareView: CustomStreamOptionView = {
        let view = CustomStreamOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.optionImageView.image = Appearance.default.images.share1
        view.optionButton.addTarget(self, action: #selector(optionTappedWithTag(_:)), for: .touchUpInside)
        view.layer.cornerRadius = 22.5
        view.optionButton.tag = StreamOption.share.rawValue
        view.isHidden = true
        return view
    }()
    
    lazy var bidderView: CustomStreamOptionView = {
        let view = CustomStreamOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.optionImageView.tintColor = Appearance.default.colors.appColor
        view.optionButton.addTarget(self, action: #selector(optionTappedWithTag(_:)), for: .touchUpInside)
        view.layer.cornerRadius = 22.5
        view.optionButton.tag = StreamOption.bidder.rawValue
        view.isHidden = true
        return view
    }()
    
    lazy var storeView: CustomStreamOptionView = {
        let view = CustomStreamOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.optionImageView.image = Appearance.default.images.vendor.withRenderingMode(.alwaysTemplate)
        view.optionImageView.tintColor = .white
        view.optionButton.addTarget(self, action: #selector(optionTappedWithTag(_:)), for: .touchUpInside)
        view.layer.cornerRadius = 22.5
        view.optionButton.tag = StreamOption.store.rawValue
        view.isHidden = true
        return view
    }()
    
    lazy var flipCameraView: CustomStreamOptionView = {
        let view = CustomStreamOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.optionImageView.image = Appearance.default.images.flipCamera
        view.optionButton.addTarget(self, action: #selector(optionTappedWithTag(_:)), for: .touchUpInside)
        view.layer.cornerRadius = 22.5
        view.optionButton.tag = StreamOption.camera.rawValue
        view.isHidden = true
        return view
    }()
    
    lazy var microphoneView: CustomStreamOptionView = {
        let view = CustomStreamOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.optionImageView.image = Appearance.default.images.micUnmuted
        view.optionButton.addTarget(self, action: #selector(optionTappedWithTag(_:)), for: .touchUpInside)
        view.layer.cornerRadius = 22.5
        view.optionButton.tag = StreamOption.microphone.rawValue
        view.isHidden = true
        return view
    }()
    
    lazy var lovedView: CustomStreamOptionView = {
        let view = CustomStreamOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.optionImageView.image = Appearance.default.images.reaction.withRenderingMode(.alwaysTemplate)
        view.optionImageView.tintColor = .white
        view.optionButton.addTarget(self, action: #selector(optionTappedWithTag(_:)), for: .touchUpInside)
        view.layer.cornerRadius = 22.5
        view.optionButton.tag = StreamOption.loved.rawValue
        view.isHidden = true
        return view
    }()
    
    lazy var speakerView: CustomStreamOptionView = {
        let view = CustomStreamOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.optionImageView.image = Appearance.default.images.audioUnmuted
        view.optionButton.addTarget(self, action: #selector(optionTappedWithTag(_:)), for: .touchUpInside)
        view.layer.cornerRadius = 22.5
        view.optionButton.tag = StreamOption.speaker.rawValue
        view.isHidden = true
        return view
    }()
    
    lazy var moreView: CustomStreamOptionView = {
        let view = CustomStreamOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.optionImageView.image = Appearance.default.images.more1
        view.optionButton.addTarget(self, action: #selector(optionTappedWithTag(_:)), for: .touchUpInside)
        view.layer.cornerRadius = 22.5
        view.optionButton.tag = StreamOption.more.rawValue
        view.isHidden = true
        return view
    }()
    
    lazy var walletView: CustomStreamOptionView = {
        let view = CustomStreamOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.optionImageView.image = Appearance.default.images.wallet
        view.optionButton.addTarget(self, action: #selector(optionTappedWithTag(_:)), for: .touchUpInside)
        view.layer.cornerRadius = 22.5
        view.optionButton.tag = StreamOption.wallet.rawValue
        view.isHidden = true
        return view
    }()
    
    lazy var analyticsView: CustomStreamOptionView = {
        let view = CustomStreamOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.optionImageView.image = Appearance.default.images.analytics
        view.optionButton.addTarget(self, action: #selector(optionTappedWithTag(_:)), for: .touchUpInside)
        view.layer.cornerRadius = 22.5
        view.optionButton.tag = StreamOption.analytics.rawValue
        view.isHidden = true
        return view
    }()
    
    lazy var settingsView: CustomStreamOptionView = {
        let view = CustomStreamOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.optionImageView.image = Appearance.default.images.more1
        view.optionButton.addTarget(self, action: #selector(optionTappedWithTag(_:)), for: .touchUpInside)
        view.layer.cornerRadius = 22.5
        view.optionButton.tag = StreamOption.settings.rawValue
        view.isHidden = true
        return view
    }()
    
    lazy var requestView: CustomStreamOptionView = {
        let view = CustomStreamOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.optionImageView.image = Appearance.default.images.request
        view.optionButton.addTarget(self, action: #selector(optionTappedWithTag(_:)), for: .touchUpInside)
        view.layer.cornerRadius = 22.5
        view.optionButton.tag = StreamOption.request.rawValue
        view.isHidden = true
        return view
    }()
    
    lazy var requestListView: CustomStreamOptionView = {
        let view = CustomStreamOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.optionImageView.image = Appearance.default.images.requestList
        view.optionButton.addTarget(self, action: #selector(optionTappedWithTag(_:)), for: .touchUpInside)
        view.layer.cornerRadius = 22.5
        view.optionButton.tag = StreamOption.requestList.rawValue
        view.isHidden = true
        return view
    }()
    
    lazy var giftView: CustomStreamOptionView = {
        let view = CustomStreamOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.optionImageView.image = Appearance.default.images.gift
        view.optionButton.addTarget(self, action: #selector(optionTappedWithTag(_:)), for: .touchUpInside)
        view.layer.cornerRadius = 22.5
        view.optionButton.tag = StreamOption.gift.rawValue
        view.isHidden = true
        return view
    }()
    
    lazy var pkInviteView: CustomStreamOptionView = {
        let view = CustomStreamOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.optionButton.setBackgroundImage(Appearance.default.images.pkLogo, for: .normal)
        view.optionButton.addTarget(self, action: #selector(optionTappedWithTag(_:)), for: .touchUpInside)
        view.layer.cornerRadius = 22.5
        view.optionButton.tag = StreamOption.pkInvite.rawValue
        view.isHidden = true
        return view
    }()
    
    lazy var stopPKBattleView: CustomStreamOptionView = {
        let view = CustomStreamOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.optionImageView.image = Appearance.default.images.stopPK
        view.optionButton.addTarget(self, action: #selector(optionTappedWithTag(_:)), for: .touchUpInside)
        view.layer.cornerRadius = 22.5
        view.optionButton.tag = StreamOption.stopPKBattle.rawValue
        view.backgroundView.backgroundColor = Appearance.default.colors.appRed
        view.isHidden = true
        return view
    }()
    
    lazy var endPKInviteView: CustomStreamOptionView = {
        let view = CustomStreamOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.optionImageView.image = Appearance.default.images.endPK
        view.optionButton.addTarget(self, action: #selector(optionTappedWithTag(_:)), for: .touchUpInside)
        view.layer.cornerRadius = 22.5
        view.optionButton.tag = StreamOption.endPKInvite.rawValue
        view.backgroundView.backgroundColor = Appearance.default.colors.appRed
        view.isHidden = true
        return view
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
        addSubview(optionStackView)
        
        optionStackView.addArrangedSubview(pkInviteView)
        optionStackView.addArrangedSubview(stopPKBattleView)
        optionStackView.addArrangedSubview(endPKInviteView)
        optionStackView.addArrangedSubview(giftView)
        optionStackView.addArrangedSubview(analyticsView)
        optionStackView.addArrangedSubview(bidderView)
        optionStackView.addArrangedSubview(highlightView)
        optionStackView.addArrangedSubview(shareView)
        optionStackView.addArrangedSubview(microphoneView)
        optionStackView.addArrangedSubview(flipCameraView)
        optionStackView.addArrangedSubview(storeView)
        optionStackView.addArrangedSubview(lovedView)
        optionStackView.addArrangedSubview(walletView)
        optionStackView.addArrangedSubview(speakerView)
        optionStackView.addArrangedSubview(requestView)
        optionStackView.addArrangedSubview(requestListView)
        optionStackView.addArrangedSubview(moreView)
        optionStackView.addArrangedSubview(settingsView)
    }
    
    func setupConstraints(){
        optionStackView.pin(to: self)
        NSLayoutConstraint.activate([
            bidderView.widthAnchor.constraint(equalToConstant: 45),
            bidderView.heightAnchor.constraint(equalToConstant: 45),
            
            highlightView.widthAnchor.constraint(equalToConstant: 45),
            highlightView.heightAnchor.constraint(equalToConstant: 45),
            
            shareView.widthAnchor.constraint(equalToConstant: 45),
            shareView.heightAnchor.constraint(equalToConstant: 45),
            
            microphoneView.widthAnchor.constraint(equalToConstant: 45),
            microphoneView.heightAnchor.constraint(equalToConstant: 45),
            
            flipCameraView.widthAnchor.constraint(equalToConstant: 45),
            flipCameraView.heightAnchor.constraint(equalToConstant: 45),
            
            storeView.widthAnchor.constraint(equalToConstant: 45),
            storeView.heightAnchor.constraint(equalToConstant: 45),
            
            lovedView.widthAnchor.constraint(equalToConstant: 45),
            lovedView.heightAnchor.constraint(equalToConstant: 45),
            
            walletView.widthAnchor.constraint(equalToConstant: 45),
            walletView.heightAnchor.constraint(equalToConstant: 45),
            
            speakerView.widthAnchor.constraint(equalToConstant: 45),
            speakerView.heightAnchor.constraint(equalToConstant: 45),
            
            moreView.widthAnchor.constraint(equalToConstant: 45),
            moreView.heightAnchor.constraint(equalToConstant: 45),
            
            analyticsView.widthAnchor.constraint(equalToConstant: 45),
            analyticsView.heightAnchor.constraint(equalToConstant: 45),
            
            settingsView.widthAnchor.constraint(equalToConstant: 45),
            settingsView.heightAnchor.constraint(equalToConstant: 45),
            
            requestView.widthAnchor.constraint(equalToConstant: 45),
            requestView.heightAnchor.constraint(equalToConstant: 45),
            
            requestListView.widthAnchor.constraint(equalToConstant: 45),
            requestListView.heightAnchor.constraint(equalToConstant: 45),
            
            giftView.widthAnchor.constraint(equalToConstant: 45),
            giftView.heightAnchor.constraint(equalToConstant: 45),
            
            endPKInviteView.widthAnchor.constraint(equalToConstant: 45),
            endPKInviteView.heightAnchor.constraint(equalToConstant: 45),
            
            stopPKBattleView.widthAnchor.constraint(equalToConstant: 45),
            stopPKBattleView.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    // MARK: ACTIONS -
    
    @objc func optionTappedWithTag(_ sender: CustomStreamOptionView){
        delegate?.didOptionsTapped(with: sender.tag)
    }

}
