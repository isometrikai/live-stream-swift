//
//  BuyCoinsViewController.swift
//  
//
//  Created by Appscrip 3Embed on 03/07/24.
//

import UIKit
import IsometrikStream

public final class BuyCoinsViewController: UIViewController, ISMStreamUIAppearanceProvider {

    // MARK: - PROPERTIES
    
    var viewModel: BuyCoinsViewModel
    
    lazy var headerView: CustomHeaderView = {
        let view = CustomHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.headerTitle.text = "Buy Coins"
        view.headerTitle.textAlignment = .center
        
        view.leadingActionButton.isHidden = false
        view.leadingActionButton.setImage(appearance.images.close.withRenderingMode(.alwaysTemplate), for: .normal)
        view.leadingActionButton.imageView?.tintColor = .black
        view.leadingActionButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        view.dividerView.isHidden = false
        return view
    }()
    
    lazy var walletBalanceHeaderView: CoinBalanceHeaderView = {
        let view = CoinBalanceHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.transactionButton.addTarget(self, action: #selector(transactionButtonTapped), for: .touchUpInside)
        return view
    }()
    
    lazy var coinPlanCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 8
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(CoinPlanCollectionViewCell.self, forCellWithReuseIdentifier: "CoinPlanCollectionViewCell")
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        collectionView.backgroundColor = .clear
        collectionView.delaysContentTouches = false
        
        return collectionView
    }()
    
    // MARK: MAIN -
    
    public init(viewModel: BuyCoinsViewModel) {
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
        getPlans()
        setupWalletBalance()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(walletBalanceHeaderView)
        view.addSubview(coinPlanCollectionView)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            walletBalanceHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            walletBalanceHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            walletBalanceHeaderView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            walletBalanceHeaderView.heightAnchor.constraint(equalToConstant: 100),
            
            coinPlanCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coinPlanCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coinPlanCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            coinPlanCollectionView.topAnchor.constraint(equalTo: walletBalanceHeaderView.bottomAnchor)
        ])
    }
    
    func getPlans(){
        viewModel.getCoinPlans { success, error in
            if success {
                self.coinPlanCollectionView.reloadData()
                self.setupWalletBalance()
            } else {
                guard let error else { return }
                print(error)
            }
        }
    }
    
    func setupWalletBalance(){
        
        let walletBalance = UserDefaultsProvider.shared.getWalletBalance()
        walletBalanceHeaderView.configureView(balance: walletBalance)
        
        viewModel.getWalletBalance { success, error in
            if success {
                self.walletBalanceHeaderView.configureView(balance: self.viewModel.walletBalance?.balance ?? 0)
            }
        }
        
    }
    
    // MARK: - ACTIONS
    
    @objc func closeButtonTapped(){
        self.dismiss(animated: true)
    }
    
    @objc func transactionButtonTapped(){
        let viewModel = WalletTransactionViewModel(isometrik: viewModel.isometrik)
        let controller = WalletTransactionViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(controller, animated: true)
    }


}
