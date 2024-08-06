//
//  RecordingPlayerCollectionViewCell.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 29/12/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

protocol RecordedStreamPlayerCellActionDelegate {
    func didRecordedStreamOptionTapped(option: RecordedStreamOptions?, index: Int)
    func didProductTapped(index: Int)
    func didAddToCartButtonTapped(index: Int)
    func didOpenCartButtonTapped(index: Int)
    func didCloseButtonTapped(index: Int)
    func didPlayButtonTapped(index: Int)
    func didScrub(_ playbackSlider:UISlider, event: UIEvent)
    func didFollowButtonTapped(index: Int)
    func didProfileButtonTapped(index: Int)
}

class RecordingPlayerCollectionViewCell: UICollectionViewCell, ISMAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    var delegate: RecordedStreamPlayerCellActionDelegate?
    
    lazy var headerView: RecordedStreamHeaderView = {
        let view = RecordedStreamHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        view.profileView.followButton.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
        view.profileView.profileDetailsButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        return view
    }()
    
    //:
    
    // Player view
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var playerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var coverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playButtonTapped))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        
        view.backgroundColor = .black.withAlphaComponent(0.3)
        
        return view
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        
        button.isHidden = true
        button.setBackgroundImage(appearance.images.play, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    //:
    
    // Side Options view
    
    lazy var streamOptionView: RecordedStreamOptionView = {
        let view = RecordedStreamOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    //:
    
    // Products View
    
    lazy var productView: RecordedStreamProductsView = {
        let view = RecordedStreamProductsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.delegate = self
        view.isHidden = true
        return view
    }()
    
    //:
    
    
    // Player Slider View
    
    lazy var sliderView: PlayerSliderView = {
        let view = PlayerSliderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    //:
    
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
        backgroundColor = .black
        addSubview(thumbnailImageView)
        addSubview(playerView)
        addSubview(coverView)
        addSubview(sliderView)
        addSubview(playButton)
        addSubview(headerView)
        addSubview(productView)
        addSubview(streamOptionView)
    }
    
    func setUpConstraints(){
        coverView.pin(to: self)
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),
            
            thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            thumbnailImageView.topAnchor.constraint(equalTo: topAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            playerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            playerView.topAnchor.constraint(equalTo: topAnchor),
            playerView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            
            sliderView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            sliderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sliderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            sliderView.heightAnchor.constraint(equalToConstant: 40),
            
            playButton.centerYAnchor.constraint(equalTo: playerView.centerYAnchor),
            playButton.centerXAnchor.constraint(equalTo: playerView.centerXAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 70),
            playButton.heightAnchor.constraint(equalToConstant: 70),
            
            productView.leadingAnchor.constraint(equalTo: leadingAnchor),
            productView.trailingAnchor.constraint(equalTo: trailingAnchor),
            productView.bottomAnchor.constraint(equalTo: sliderView.topAnchor, constant: -10),
            productView.heightAnchor.constraint(equalToConstant: 100),
            
            streamOptionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            streamOptionView.bottomAnchor.constraint(equalTo: sliderView.topAnchor, constant: -20)
        ])
    }
    
    func manageData(isometrik: IsometrikSDK?, streamData: ISMStream?){
        
        guard let isometrik,
              let streamData,
              let recordingUrls = streamData.recordedUrl,
              !recordingUrls.isEmpty
        else {
            thumbnailImageView.image = UIImage()
            return
        }

        let streamImage = streamData.streamImage.unwrap

        guard let url = URL(string: streamImage) else {
            thumbnailImageView.image = UIImage()
            return
        }
        
        thumbnailImageView.kf.setImage(with: url)

        // header updates
        headerView.configureData(streamData: streamData, isometrik: isometrik)
        
    }
    
    // MARK: - ACTIONS
    
    @objc func closeButtonTapped(){
        delegate?.didCloseButtonTapped(index: self.tag)
    }
    
    @objc func cartButtonTapped(){
        delegate?.didOpenCartButtonTapped(index: self.tag)
    }
    
    @objc func playButtonTapped(){
        delegate?.didPlayButtonTapped(index: self.tag)
    }
    
    @objc func followButtonTapped(){
        delegate?.didFollowButtonTapped(index: self.tag)
    }
    
    @objc func profileButtonTapped(){
        delegate?.didProfileButtonTapped(index: self.tag)
    }
    
}
