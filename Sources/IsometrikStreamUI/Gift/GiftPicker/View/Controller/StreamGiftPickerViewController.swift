//
//  StreamGiftPickerViewController.swift
//  PicoAdda
//
//  Created by Appscrip 3Embed on 11/03/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import UIKit
import AVFoundation
import IsometrikStream

class StreamGiftPickerViewController: UIViewController {

    // MARK: - PROPERTIES
    var viewModel: StreamGiftViewModel
    var contentBottomConstraint: NSLayoutConstraint?
    var audioPlayer:AVAudioPlayer?
    
    let contentViewHeight: CGFloat = UIScreen.main.bounds.height * 0.6
    
    lazy var coverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.3)
        view.alpha = 0
        view.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTapped))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()
    
    lazy var contentView: StreamGiftContentView = {
        let view = StreamGiftContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.7)
        
        view.headerView.closeButton.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        view.headerView.getMoreButton.addTarget(self, action: #selector(getMoreTapped), for: .touchUpInside)
        
        view.giftGroupHeaderView.delegate = self
        view.giftContentItemView.delegate = self
        
        return view
    }()
    
    // MARK: MAIN -
    
    init(isometrik: IsometrikSDK,
         streamInfo: ISMStream,
         recieverGiftData: ISMCustomGiftRecieverData
    ) {
        
        let viewModel = StreamGiftViewModel(
            isometrik: isometrik,
            streamInfo: streamInfo,
            recieverGiftData: recieverGiftData
        )
        
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        
        DispatchQueue.main.async {
            self.animateIn()
        }
        
        loadDataInitially()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        view.backgroundColor = .clear
        view.addSubview(coverView)
        view.addSubview(contentView)
    }
    
    func setUpConstraints(){
        coverView.ism_pin(to: view)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.heightAnchor.constraint(equalToConstant: self.contentViewHeight + ism_windowConstant.getBottomPadding)
        ])
        
        contentBottomConstraint = contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: UIScreen.main.bounds.height + self.contentViewHeight + ism_windowConstant.getBottomPadding)
        contentBottomConstraint?.isActive = true
        
    }
    
    func animateIn(){
        coverView.isHidden = false
        UIView.animate(withDuration: 0.4) {
            self.coverView.alpha = 1
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseIn]) {
            self.contentBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func animateOut(){
        self.contentBottomConstraint?.constant = self.contentViewHeight + ism_windowConstant.getBottomPadding
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut]) {
            self.view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.4) {
            self.coverView.alpha = 0
        } completion: { finished in
            self.coverView.isHidden = true
            self.dismiss(animated: true)
        }
    }
    
    // MARK: - ACTIONS
    
    @objc func dismissTapped(){
        animateOut()
    }
    
    @objc func getMoreTapped(){
        
    }

}

extension StreamGiftPickerViewController: GiftGroupActionProtocol, StreamGiftItemActionProtocol {
    
    func didGiftItemSelected(giftData: ISMStreamGiftModel) {
        // transfer gift api here
        viewModel.sendGift(giftData: giftData)
        
        // animate coins
        self.showCoinAnymation(coins: String(giftData.virtualCurrency ?? 0))
    }
    
    func callForNextPage(groupId: String) {
        
        // get from server
        self.viewModel.getGiftForGroups(giftGroupId: groupId) { success, error in
            if success {
                let data = self.viewModel.getGiftItemsForGroup(groupId: groupId)
                if data.0.isEmpty {
                    self.contentView.giftContentItemView.defaultLabel.isHidden = false
                }
                self.contentView.giftContentItemView.totalCount = data.1
                self.contentView.giftContentItemView.data = data.0
            } else {
                // show error
            }
        }
    }
    
    func giftGroupTapped(groupId: String, giftGroupTitle: String) {
        viewModel.selectedGroupTitle = giftGroupTitle
        loadGiftItemsForGroup(groupId: groupId)
    }
    
    func loadDataInitially(){
        
        let group = DispatchGroup()
        group.enter()
        
        contentView.startAnimating()
        
        viewModel.getGiftGroups { success, error in
            
            if success {
                if self.viewModel.giftGroup.count > 0 {
                    
                    // update the collections
                    self.contentView.giftGroupHeaderView.data = self.viewModel.giftGroup
                    self.contentView.giftGroupHeaderView.collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
                    
                    group.leave()
                } else {
                    self.contentView.stopAnimating()
                }
            } else {
                self.contentView.stopAnimating()
                // show error
            }
            
        }
        
        group.notify(queue: .main) {
            
            guard let giftsForGroupData = self.viewModel.selectedGiftGroupData,
                  let giftGroupId = giftsForGroupData.id
            else {
                self.contentView.stopAnimating()
                return
            }
            
            self.loadGiftItemsForGroup(groupId: giftGroupId)
        }
        
    }
    
    func loadGiftItemsForGroup(groupId id: String) {
        
        let giftData = self.viewModel.getGiftItemsForGroup(groupId: id)
        
        self.contentView.giftContentItemView.totalCount = giftData.1
        self.contentView.giftContentItemView.data = giftData.0
        self.contentView.giftContentItemView.defaultLabel.isHidden = true
        
        if giftData.0.isEmpty {
            
            self.contentView.startAnimating()
            
            // get from server
            self.viewModel.getGiftForGroups(giftGroupId: id) { success, error in
                self.contentView.stopAnimating()
                if success {
                    let data = self.viewModel.getGiftItemsForGroup(groupId: id)
                    if data.0.isEmpty {
                        self.contentView.giftContentItemView.defaultLabel.isHidden = false
                    }
                    self.contentView.giftContentItemView.totalCount = data.1
                    self.contentView.giftContentItemView.data = data.0
                } else {
                    // show error
                }
            }
            
        } else {
            
            // show saved items
            self.contentView.stopAnimating()
            self.contentView.giftContentItemView.totalCount = giftData.1
            self.contentView.giftContentItemView.data = giftData.0
            
        }
        
    }
    
}

extension StreamGiftPickerViewController {
    
    func playCoinsSound() {
        guard let path = Bundle.main.path(forResource: "Coin-collect-sound-effect", ofType: "mp3") else{
            return
        }
        guard let url = URL(string: path) else{return}
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    func showCoinAnymation(coins: String){
        self.playCoinsSound()
//        for i in 1..<7 {
//            self.view.applyCoinsAnimation(
//                indexAt:i,
//                fromView: self.contentView.headerView.balanceLabel,
//                coins: coins,
//                image: UIImage(named: "dollar")
//            )
//        }
    }
    
}
