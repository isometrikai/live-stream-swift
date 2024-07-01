//
//  VideoContainerCell.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 31/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit
import Kingfisher
import Lottie
import IsometrikStream

protocol VideoContainerActionDelegate {
    func didMoreOptionTapped(index: Int, videoSession: VideoSession?)
    func didRTMPMemberViewTapped(index: Int)
}

class VideoContainerCell: UICollectionViewCell, AppearanceProvider {
    
    // MARK: - PROPERTIES
    
    var isometrik: IsometrikSDK?
    var isPKStream: Bool = false
    var videoSession: VideoSession? {
        didSet {
            configureData()
            setNeedsLayout()
        }
    }
    
    var delegate: VideoContainerActionDelegate?
    
    var videoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - PK SESSION PROFILE VIEW
    
    let pkSessionGuestProfile: PKSessionGuestProfileView = {
        let view = PKSessionGuestProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    let pkSessionHostProfile: PKSessionHostProfileView = {
        let view = PKSessionHostProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    // MARK: - WINNER VIEWS
    
    let confettiView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.animation = LottieAnimation.named("confetti")
        view.loopMode = LottieLoopMode.loop
        view.isHidden = true
        return view
    }()
    
    let winningStatusImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - PROFILE VIEW
    
    let sessionProfileView: CustomVideoSessionProfileView = {
        let view = CustomVideoSessionProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileView: CustomVideoSessionProfileView = {
        let view = CustomVideoSessionProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    //:
    
    lazy var muteImage: CustomVideoContainerImageView = {
        let view = CustomVideoContainerImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.backgroundColor = .black.withAlphaComponent(0.7)
        
        view.cardImage.image = appearance.images.speakerOff.withRenderingMode(.alwaysTemplate)
        view.cardImage.tintColor = .white
        view.cardImage.contentMode = .scaleAspectFit
        view.cardImageWidthAnchor?.constant = 10
        
        view.isHidden = true
        
        return view
    }()
    
    lazy var moreOptionView: CustomVideoContainerImageView = {
        let view = CustomVideoContainerImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.layer.cornerRadius = 12
        
        view.cardButton.addTarget(self, action: #selector(moreOptionTapped), for: .touchUpInside)
        
        view.cardImage.image = appearance.images.more2.withRenderingMode(.alwaysTemplate)
        view.cardImage.tintColor = .white
        view.cardImageWidthAnchor?.constant = 10
        view.cardImageHeightAnchor?.constant = 10
        
        view.isHidden = true
        
        return view
    }()
    
    // MARK: - Battle animation View
    
    let battleProfileView: CustomBattleProfileView = {
        let view = CustomBattleProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    // MARK: - RTMP DEFAULT VIEW
    
    let rtmpDefaultView: CustomRTMPMemberView = {
        let view = CustomRTMPMemberView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.actionButton.addTarget(self, action: #selector(rtmpActionButtonTapped), for: .touchUpInside)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let videoSession,
              let isometrik else {
            return
        }
        
        if videoSession.sessionFrom == .liveKit {
            guard let videoView = videoSession.liveKitVideoView
            else { return }
            
            let isStreamRTMP = isometrik.getUserSession().getRTMPStatus()
            let isUserHost = videoSession.userData?.isAdmin ?? false
            
            if isStreamRTMP && isUserHost {
                videoView.layoutMode = .fit
            } else {
                videoView.layoutMode = .fill
            }
            
            videoView.contentMode = .scaleAspectFit
            videoView.setNeedsLayout()
        }
        
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        backgroundColor = .black
        //addSubview(rtmpDefaultView)
        addSubview(sessionProfileView)
        addSubview(videoView)
        
        addSubview(winningStatusImage)
        addSubview(confettiView)
        
        addSubview(profileView)
        addSubview(muteImage)
        
        // session user info view
        addSubview(pkSessionGuestProfile)
        addSubview(pkSessionHostProfile)
        
        //addSubview(moreOptionView)
        addSubview(battleProfileView)
    }
    
    func setupConstraints(){
        //rtmpDefaultView.pin(to: self)
        videoView.ism_pin(to: self)
        sessionProfileView.ism_pin(to: self)
        profileView.ism_pin(to: self)
        battleProfileView.ism_pin(to: self)
        NSLayoutConstraint.activate([
            muteImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            muteImage.bottomAnchor.constraint(equalTo: self.sessionProfileView.profilePicture.topAnchor, constant: -5),
            muteImage.widthAnchor.constraint(equalToConstant: 30),
            muteImage.heightAnchor.constraint(equalToConstant: 30),
            
//            moreOptionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
//            moreOptionView.widthAnchor.constraint(equalToConstant: 24),
//            moreOptionView.heightAnchor.constraint(equalToConstant: 24),
//            moreOptionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            
            pkSessionGuestProfile.leadingAnchor.constraint(equalTo: leadingAnchor),
            pkSessionGuestProfile.trailingAnchor.constraint(equalTo: trailingAnchor),
            pkSessionGuestProfile.topAnchor.constraint(equalTo: topAnchor),
            pkSessionGuestProfile.heightAnchor.constraint(equalToConstant: 50),
            
            pkSessionHostProfile.leadingAnchor.constraint(equalTo: leadingAnchor),
            pkSessionHostProfile.trailingAnchor.constraint(equalTo: trailingAnchor),
            pkSessionHostProfile.topAnchor.constraint(equalTo: topAnchor),
            pkSessionHostProfile.heightAnchor.constraint(equalToConstant: 50),
            
            winningStatusImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            winningStatusImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            winningStatusImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            winningStatusImage.heightAnchor.constraint(equalToConstant: 120),
            
            confettiView.leadingAnchor.constraint(equalTo: leadingAnchor),
            confettiView.trailingAnchor.constraint(equalTo: trailingAnchor),
            confettiView.bottomAnchor.constraint(equalTo: bottomAnchor),
            confettiView.topAnchor.constraint(equalTo: topAnchor)
            
        ])
    }
    
    func configureData(){
        
        guard let videoSession else { return }
        
        setupVideoViews()
        setVideoAudioUpdate()
        updateMoreOptionView()
        
        guard let isometrik else { return }
        
        if isometrik.isPKBattlesEnabled() && isPKStream {
            
            moreOptionView.isHidden = true
            
            if self.tag == 0 {
                pkSessionGuestProfile.isHidden = true
                pkSessionHostProfile.isHidden = false
            } else {
                pkSessionGuestProfile.isHidden = false
                pkSessionHostProfile.isHidden = true
            }
            
            if videoSession.userData?.isAdmin != nil || videoSession.userData?.isAdmin ?? false {
                // host
                battleProfileView.coverImageView.image = appearance.images.battleHostBackground
                
            } else {
                // guest
                battleProfileView.coverImageView.image = appearance.images.battleGuestBackground
            }
            
            pkSessionGuestProfile.data = videoSession.userData
            pkSessionHostProfile.data = videoSession.userData
            
            // handling the winning and loosing scenarios
            guard let winnersData = videoSession.winnersData else { return }
            
            if winnersData.winnerId == videoSession.userData?.userID {
                
                // show winner image
                winningStatusImage.isHidden = false
                winningStatusImage.image = appearance.images.pkWinner
                
                // show confetti
                confettiView.isHidden = false
                confettiView.play()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    self.winningStatusImage.isHidden = true
                    self.confettiView.isHidden = true
                    self.confettiView.pause()
                    self.videoSession?.winnersData = nil
                }
                
            } else {
                
                // show looser image
                winningStatusImage.isHidden = false
                winningStatusImage.image = appearance.images.pkLoser
                
                // hide confetti
                confettiView.isHidden = true
                confettiView.pause()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    self.winningStatusImage.isHidden = true
                    self.videoSession?.winnersData = nil
                }
                
            }
            
            playStatusAnimation()
            
        }
        else {
            pkSessionHostProfile.isHidden = true
            pkSessionGuestProfile.isHidden = true
        }
        
    }
    
    func setVideoAudioUpdate(){
        
        guard let videoSession = videoSession,
              let userData = videoSession.userData
        else {
            return
        }
        
        sessionProfileView.profilePicture.image = UIImage()
        sessionProfileView.usernameLabel.text = ""
        
        if userData.userProfileImageURL != UserDefaultsProvider.shared.getIsometrikDefaultProfile() {
            if let imageURL = URL(string: userData.userProfileImageURL ?? "") {
                sessionProfileView.profilePicture.kf.setImage(with: imageURL)
            }
        }
        
        if let imageURL = URL(string: userData.userProfileImageURL ?? "") {
            sessionProfileView.backgroundImage.kf.setImage(with: imageURL)
        }
        
        let userName = userData.userName ?? ""
        
        let initialText = "\(userName.prefix(2))"
        print("USER INITIALS ::: \(initialText)")
        sessionProfileView.defaultProfilePicture.initialsText.text = "\(initialText)".uppercased()
        sessionProfileView.usernameLabel.text = userName
        
        if videoSession.isVideoMute {
            sessionProfileView.isHidden = false
            videoView.isHidden = true
        } else {
            sessionProfileView.isHidden = true
            videoView.isHidden = false
        }
        
        if videoSession.isAudioMute {
            muteImage.isHidden = false
        } else {
            muteImage.isHidden = true
        }
        
    }
    
    func setupVideoViews(){
        
        guard let videoSession = videoSession else {
            return
        }
        
        // remove all subviews if present
        self.videoView.subviews.forEach({ $0.removeFromSuperview() })
        
        guard let view = videoSession.liveKitVideoView else { return }
        self.videoView.addSubview(view)
        view.ism_pin(to: self.videoView)
        
    }
    
    func updateMoreOptionView(){
        
        guard let videoSession = videoSession else { return }
        
        if !isPKStream {
            
            let currentUserId = isometrik?.getUserSession().getUserId().ism_userIdUInt()
            let userType = isometrik?.getUserSession().getUserType()
            
            if videoSession.uid == currentUserId  {
                moreOptionView.isHidden = true
            } else {
                if let isPublishing = videoSession.userData?.isPublishing {
                    if isPublishing {
                        moreOptionView.isHidden = false
                        sessionProfileView.liveStatusView.isHidden = true
                    } else {
                        sessionProfileView.liveStatusView.isHidden = false
                        if userType == .host {
                            moreOptionView.isHidden = false
                        } else {
                            moreOptionView.isHidden = true
                        }
                    }
                }
            }
            
            // hide more button if viewer
            if userType == .viewer {
                moreOptionView.isHidden = true
            }
            
            
        } else {
            moreOptionView.isHidden = true
        }
        
    }
    
    func playStatusAnimation(){
        self.winningStatusImage.transform = .identity
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1) {
            self.winningStatusImage.transform = .init(scaleX: 1.8, y: 1.8)
        }
    }
    
    func playBattleStartAnimation(){
        
        guard let videoSession = videoSession, let userData = videoSession.userData else {
            return
        }
        
        // unhide all the views
        battleProfileView.isHidden = false
        UIView.animate(withDuration: 0.9, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1 , animations: {
            
            self.battleProfileView.coverImageView.alpha = 1
            self.battleProfileView.profileView.alpha = 1
            self.battleProfileView.profileView.transform = .init(scaleX: 1.9, y: 1.9)
            self.battleProfileView.profileView.center.y -= 50
            
        }, completion: { finished in
            UIView.animate(withDuration: 0.6, delay: 3, usingSpringWithDamping: 0.7, initialSpringVelocity: 1 , animations: {
                
                self.battleProfileView.coverImageView.alpha = 0
                self.battleProfileView.profileView.alpha = 0
                self.battleProfileView.profileView.transform = .identity
                self.battleProfileView.profileView.center.y += 150
                
                if userData.isAdmin != nil && userData.isAdmin ?? false {
                    self.battleProfileView.profileView.center.x -= 100
                } else {
                    self.battleProfileView.profileView.center.x += 100
                }
                
            }, completion: { finished in
                self.battleProfileView.isHidden = true
                self.battleProfileView.profileView.center.y -= 100
                if userData.isAdmin != nil && userData.isAdmin ?? false {
                    self.battleProfileView.profileView.center.x += 100
                } else {
                    self.battleProfileView.profileView.center.x -= 100
                }
            })
        })
        
    }
    
    func setupRTMPDefaultView(){
        
        guard let isometrik else { return }
        let userType = isometrik.getUserSession().getUserType()
        
        // change as per user type
        
        switch userType {
        case .viewer:
            
            rtmpDefaultView.defaultImageView.image = appearance.images.joinStream
            rtmpDefaultView.defaultLabel.text = "Join"
            
            break
        case .host:
            
            rtmpDefaultView.defaultImageView.image = appearance.images.plus
            rtmpDefaultView.defaultLabel.text = "Add"
            
            break
        case .member:
            
            rtmpDefaultView.defaultImageView.image = appearance.images.joinStream
            rtmpDefaultView.defaultLabel.text = "Waiting.."
            
            break
        case .moderator:
            
            rtmpDefaultView.defaultImageView.image = appearance.images.joinStream
            rtmpDefaultView.defaultLabel.text = "Join"
            
            break
        case .none:
            break
        case .guest:
            break
        }
        
        // clearing all layer before putting gradient layer to prevent gradient redundancy
        if let _ = self.rtmpDefaultView.layer.sublayers {
            self.rtmpDefaultView.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
        }
        
        self.rtmpDefaultView.ism_setGradient(withColors: [appearance.colors.appSecondary.cgColor, appearance.colors.appColor.cgColor], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1))
    }
    
}
