//
//  VerticalStreamCollectionViewCell.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 07/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

class VerticalStreamCollectionViewCell: UICollectionViewCell {
    
    // MARK: - PROPERTIES
    
    var delegate: StreamCellActionDelegate?
    
    var viewModel: StreamViewModel? {
        didSet {
            manageData()
        }
    }
    
    lazy var streamContainer: StreamContainerView = {
        let containerView = StreamContainerView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.streamOptionsView.delegate = self
        containerView.streamMessageView.delegate = self
        return containerView
    }()
    
    let streamThumbnailImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var streamLoader: CustomStreamLoaderView = {
        let loaderView = CustomStreamLoaderView()
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        return loaderView
    }()
    
    let streamEndView: StreamEndView = {
        let view = StreamEndView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    let scheduleStreamView: ScheduleStreamView = {
        let view = ScheduleStreamView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    let previewPlayerView: StreamPreviewVideoView = {
        let view = StreamPreviewVideoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    // MARK: - MAIN
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        addActionTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        backgroundColor = .black
        addSubview(streamThumbnailImage)
        addSubview(previewPlayerView)
        addSubview(streamContainer)
        addSubview(scheduleStreamView)
        addSubview(streamLoader)
        addSubview(streamEndView)
    }
    
    func setupConstraints(){
        scheduleStreamView.ism_pin(to: self)
        previewPlayerView.ism_pin(to: self)
        streamContainer.ism_pin(to: self)
        streamLoader.ism_pin(to: self)
        streamEndView.ism_pin(to: self)
        
        //let estimatedRatioHeight = (UIScreen.main.bounds.width * (16/9))
        
        NSLayoutConstraint.activate([
            streamThumbnailImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            streamThumbnailImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            streamThumbnailImage.topAnchor.constraint(equalTo: topAnchor),
            streamThumbnailImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
    
    func manageData(){
        setupStreamOptions()
        setStreamHeaderView()
        setStreamFooterView()
        setVideoContainer()
    }
    
    func setVideoContainer(){
        guard let viewModel,
              let isometrik = viewModel.isometrik,
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        streamContainer.videoContainer.isometrik = isometrik
        streamContainer.videoContainer.streamInfo = streamData
    }
    
}
