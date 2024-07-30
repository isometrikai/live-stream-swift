//
//  StreamGiftPickerViewController.swift
//  PicoAdda
//
//  Created by Appscrip 3Embed on 11/03/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

class StreamGiftPickerViewController: UIViewController, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    var viewModel: StreamGiftViewModel
    
    lazy var contentView: StreamGiftContentView = {
        let view = StreamGiftContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.headerView.closeButton.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        view.headerView.getMoreButton.addTarget(self, action: #selector(getMoreTapped), for: .touchUpInside)
        
        view.giftGroupHeaderView.delegate = self
        view.giftContentItemView.delegate = self
        
        return view
    }()
    
    // MARK: MAIN -
    
    init(viewModel: StreamGiftViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
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
        view.backgroundColor = .black.withAlphaComponent(0.7)
        view.addSubview(contentView)
    }
    
    func setUpConstraints(){
        contentView.ism_pin(to: view)
    }
    
    func loadWalletBalance(){
        
        let headerView = contentView.headerView
        
        // get wallet balance from userdefaults first
        let balance = UserDefaultsProvider.shared.getWalletBalance(currencyType: WalletCurrencyType.coin.getValue)
        
        if balance == 0 {
            headerView.getMoreButton.setTitle("Buy coins", for: .normal)
        } else {
            headerView.getMoreButton.setTitle("Get more", for: .normal)
        }
        
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
        self.dismiss(animated: true)
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
