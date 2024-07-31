//
//  StreamViewController.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 25/10/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

final public class 
StreamViewController: UIViewController {

    // MARK: - PROPERTIES
    
    var viewModel:StreamViewModel
    
    lazy var streamCollectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.bounces = false
        
        collectionView.register(VerticalStreamCollectionViewCell.self, forCellWithReuseIdentifier: "VerticalStreamCollectionViewCell")
        
        return collectionView
        
    }()
    
    let countDownView: CustomCountdownView = {
        let view = CustomCountdownView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    // MARK: - MAIN
    
    public init(viewModel: StreamViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        self.setupDefaults()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.removePlayerObserver()
        self.removePlayer()
        self.removeAllObservers()
        UserDefaultsProvider.shared.removeStreamData()
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        view.addSubview(streamCollectionView)
        view.addSubview(countDownView)
    }
    
    func setupConstraints(){
        countDownView.ism_pin(to: view)
        NSLayoutConstraint.activate([
            streamCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            streamCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            streamCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            streamCollectionView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    func setupDefaults() {
        
        let isometrik = viewModel.isometrik
        isometrik.getIsometrik().rtcWrapper.rtcWrapperDelegate = self
        
        // basic configurations
        viewModel.setStreaming()
        
        // remove observes
        removeAllObservers()
        
        // Add Stream Observers
        addStreamObservers()
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let indexPath = viewModel.selectedStreamIndex
            self.streamCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
        }
        
        self.streamCollectionView.reloadData()
        
        // stop screen to going to sleep
        UIApplication.shared.isIdleTimerDisabled = true
        
    }
    
    
    func fullyVisibleCells(_ inCollectionView: UICollectionView) ->  VerticalStreamCollectionViewCell? {
        
        let visibleCells = inCollectionView.visibleCells
        if visibleCells.count > 1 {
            let  visibleIndexPath = visibleCells[1]
            return visibleIndexPath as? VerticalStreamCollectionViewCell
        } else if visibleCells.count > 0 {
            return visibleCells[0] as? VerticalStreamCollectionViewCell
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
    
    func removePlayer(){
        guard let player = viewModel.videoPreviewPlayer
        else { return }
        
        player.pause()
        viewModel.videoPreviewPlayer = nil
    }

}
