//
//  RecordedStreamPlayerViewController.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 26/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import AVFoundation
import Kingfisher

public enum PlayerState {
    case pause
    case play
    case replay
}

final public class RecordedStreamPlayerViewController: UIViewController {

    // MARK: PROPERTIES -
    
    var viewModel: RecordedStreamViewModel
    
    lazy var recordingPlayerCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
        
        collectionView.register(RecordingPlayerCollectionViewCell.self, forCellWithReuseIdentifier: "RecordingPlayerCollectionViewCell")
        
        return collectionView
    }()
    
    // MARK: MAIN -
    
    public init(viewModel: RecordedStreamViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        self.recordingPlayerCollectionView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIScene.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIScene.willEnterForegroundNotification, object: nil)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        guard let selectedIndex = viewModel.selectedIndex else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.recordingPlayerCollectionView.scrollToItem(at: selectedIndex, at: .centeredVertically, animated: false)
        }
    }
    
    deinit {
        print("CameraPreviewViewController Deinitialized.....")
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        view.backgroundColor = .black
        view.addSubview(recordingPlayerCollectionView)
    }
    
    func setUpConstraints(){
        recordingPlayerCollectionView.pin(to: view)
    }
    
    func fullyVisibleCells(_ inCollectionView: UICollectionView) ->  RecordingPlayerCollectionViewCell? {
        
        let visibleCells = inCollectionView.visibleCells
        if visibleCells.count > 1 {
            let  visibleIndexPath = visibleCells[1]
            return visibleIndexPath as? RecordingPlayerCollectionViewCell
        } else if visibleCells.count > 0 {
            return visibleCells[0] as? RecordingPlayerCollectionViewCell
        }
        return nil
        
    }
    
    func fullyVisibleIndex(_ inCollectionView: UICollectionView) ->  IndexPath? {
        
        let visibleCells = inCollectionView.indexPathsForVisibleItems
        if visibleCells.count > 1 {
            let  visibleIndexPath = visibleCells[1]
            return visibleIndexPath
        } else if visibleCells.count > 0 {
            return visibleCells[0]
        }
        return nil
        
    }
    
    func addPlayerObserver(){
        
        guard let visibleCell = fullyVisibleCells(recordingPlayerCollectionView),
              let player = viewModel.player
        else { return }
        
        /// It plays the video again once it reached its end
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { [weak self] _ in

            visibleCell.playButton.isHidden = false
            visibleCell.playButton.setBackgroundImage(UIImage(named: "ism_replay"), for: .normal)

            self?.viewModel.playerState = .replay
        }
    }
    
    func removePlayerObserver(){
        
        guard let player = viewModel.player
        else { return }
        
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
    }
    
    // MARK: - ACTIONS
    
    @objc func dismissController(){
        
        guard let player = viewModel.player else {
            self.dismiss(animated: true)
            return
        }
        
        DispatchQueue.main.async {
            self.viewModel.player?.pause()
            self.viewModel.player = nil
            self.dismiss(animated: true)
        }
    }
    
    @objc func playButtonTapped(){
        
    }
    
    @objc func soundButtonTapped() {
        
    }
    
    
    // MARK: - OBSERVER ACTIONS FOR APP LIFE CYCLE
    
    @objc func applicationDidEnterBackground(){
        guard let player = viewModel.player else {
            self.dismiss(animated: true)
            return
        }
        
        DispatchQueue.main.async {
            player.pause()
        }
    }
    
    @objc func applicationWillEnterForeground(){
        guard let player = viewModel.player else {
            self.dismiss(animated: true)
            return
        }
        
        DispatchQueue.main.async {
            player.play()
        }
    }
    
    

}

