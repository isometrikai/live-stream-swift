//
//  CustomVideoContainer.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 31/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit
import IsometrikStream

class CustomVideoContainer: UIView {
    
    // MARK: - PROPERTIES
    
    var isometrik: IsometrikSDK?
    var streamInfo: ISMStream?
    var delegate: VideoContainerActionDelegate?
    
    var currentPoint: CGFloat = 0
    var currentStreamer1Coin = 0
    var currentStreamer2Coin = 0
    var animatedOnce = false
    
    var videoSessions: [VideoSession] = [] {
        didSet {
            self.refreshPKView()
            self.configureCompositionalLayout(withCells: videoSessions.count)
            self.videoContainerCollectionView.reloadData()
        }
    }
    
    var giftData: ISM_PK_LocalGiftModel? {
        didSet {
            refreshBattleProgress()
        }
    }
    
    var winnerData: ISM_PK_WinnerData? {
        didSet {
            refreshBanners()
        }
    }
    
    var battleOn: Bool? {
        didSet {
            animatedOnce = false
            refreshBattleProgress()
            self.videoContainerCollectionView.reloadData()
        }
    }
    
    lazy var videoContainerCollectionView: UICollectionView = {
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.showsVerticalScrollIndicator = false
        collectionview.register(VideoContainerCell.self, forCellWithReuseIdentifier: "VideoContainerCell")
        collectionview.contentInsetAdjustmentBehavior = .never
        collectionview.backgroundColor = .clear
        
        collectionview.isScrollEnabled = false
        collectionview.bounces = false
        
        return collectionview
    }()
    
    lazy var pkOverlayView: PKOverlayView = {
        let view = PKOverlayView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - MAIN
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        
        // Removing MTKRenderView
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            for i in 0..<self.subviews.count  {
                let subview = self.subviews[i] as UIView
                // if i == 1
                if i == 2 {
                    subview.removeFromSuperview()
                }
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        addSubview(videoContainerCollectionView)
        addSubview(pkOverlayView)
    }
    
    func setupConstraints(){
        videoContainerCollectionView.ism_pin(to: self)
        NSLayoutConstraint.activate([
            pkOverlayView.topAnchor.constraint(equalTo: topAnchor, constant: ism_windowConstant.getTopPadding + 90),
            pkOverlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pkOverlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pkOverlayView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width/2) * (4.0/3.0))
        ])
    }

}
