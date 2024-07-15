//
//  StreamGiftPickerViewController.swift
//  PicoAdda
//
//  Created by Appscrip 3Embed on 11/03/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

class StreamGiftPickerViewController: UIViewController, ISMStreamUIAppearanceProvider {

    // MARK: - PROPERTIES
    var viewModel: StreamGiftViewModel
    
    lazy var coverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = appearance.colors.appDarkGray.withAlphaComponent(0.4)
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
    
    init(isometrik: IsometrikSDK, streamInfo: ISMStream, recieverGiftData: ISMCustomGiftRecieverData){
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        loadWalletBalance()
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
            contentView.heightAnchor.constraint(equalToConstant: viewModel.contentViewHeight + ism_windowConstant.getBottomPadding)
        ])
        
        viewModel.contentBottomConstraint = contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: UIScreen.main.bounds.height + viewModel.contentViewHeight + ism_windowConstant.getBottomPadding)
        viewModel.contentBottomConstraint?.isActive = true
        
    }
    
    func animateIn() {
        coverView.isHidden = false
        
        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.8) {
            self.coverView.alpha = 1
            self.viewModel.contentBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    func animateOut() {
        
        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.8) {
            self.coverView.alpha = 0
            self.viewModel.contentBottomConstraint?.constant = self.viewModel.contentViewHeight + ism_windowConstant.getBottomPadding
            self.view.layoutIfNeeded()
        }
        
        animator.addCompletion { position in
            if position == .end {
                self.coverView.isHidden = true
                self.dismiss(animated: true)
            }
        }
        animator.startAnimation()
    }

    
    func loadWalletBalance(){
        
        let headerView = contentView.headerView
        
        // get wallet balance from userdefaults first
        let balance = UserDefaultsProvider.shared.getWalletBalance()
        headerView.coinAmount.text = "\(Int64(balance)) coins"
        
        // if any change happened fetch from server
        viewModel.getWalletBalance { success, error in
            if success {
                headerView.coinAmount.text = "\(Int64(self.viewModel.walletBalance)) coins"
            }
        }
    }
    
    // MARK: - ACTIONS
    
    @objc func dismissTapped(){
        animateOut()
    }
    
    @objc func getMoreTapped(){
        let viewModel = BuyCoinsViewModel(isometrik: self.viewModel.isometrik)
        let controller = BuyCoinsViewController(viewModel: viewModel)
        
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .pageSheet
        
        if let sheet = navigationController.sheetPresentationController {
            if #available(iOS 16.0, *) {
                // Configure the custom detent
                let customDetent = UISheetPresentationController.Detent.custom { context in
                    return context.maximumDetentValue * 0.7  // 60% of the screen height
                }
                sheet.detents = [customDetent]
                sheet.selectedDetentIdentifier = customDetent.identifier
                sheet.preferredCornerRadius = 0
            } else {
                // Fallback on earlier versions
                sheet.preferredCornerRadius = 0
                sheet.detents = [.medium()]
            }
        }
        
        present(navigationController, animated: true, completion: nil)
        
    }

}
