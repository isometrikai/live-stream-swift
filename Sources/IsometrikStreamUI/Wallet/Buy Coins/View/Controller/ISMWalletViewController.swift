//
//  BuyCoinsViewController.swift
//  
//
//  Created by Appscrip 3Embed on 03/07/24.
//

import UIKit
import IsometrikStream
import SkeletonView

public final class ISMWalletViewController: UIViewController, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var viewModel: ISMWalletViewModel
    
    lazy var headerView: CustomHeaderView = {
        let view = CustomHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.headerTitle.text = "Wallet"
        view.headerTitle.textColor = .black
        view.headerTitle.textAlignment = .center
        
        view.leadingActionButton.isHidden = false
        view.leadingActionButton.setImage(appearance.images.close.withRenderingMode(.alwaysTemplate), for: .normal)
        view.leadingActionButton.imageView?.tintColor = .black
        view.leadingActionButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        view.dividerView.isHidden = false
        return view
    }()
    
    lazy var walletBalanceHeaderView: ISMWalletBalanceHeaderView = {
        let view = ISMWalletBalanceHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.coinFeatureView.featureActionButton.addTarget(self, action: #selector(transactionButtonTapped(_:)), for: .touchUpInside)
        view.moneyFeatureView.featureActionButton.addTarget(self, action: #selector(transactionButtonTapped(_:)), for: .touchUpInside)
        view.isSkeletonable = true
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
        collectionView.isSkeletonable = true
        
        return collectionView
    }()
    
    // MARK: MAIN -
    
    public init(viewModel: ISMWalletViewModel) {
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
            walletBalanceHeaderView.heightAnchor.constraint(equalToConstant: 180),
            
            coinPlanCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coinPlanCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coinPlanCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            coinPlanCollectionView.topAnchor.constraint(equalTo: walletBalanceHeaderView.bottomAnchor)
        ])
    }
    
    func getPlans(){
        
        self.walletBalanceHeaderView.showAnimatedSkeleton(usingColor: .clouds, transition: .crossDissolve(0.5))
        self.coinPlanCollectionView.showAnimatedSkeleton(usingColor: .clouds, transition: .crossDissolve(0.5))
        
        viewModel.getCoinPlans { success, error in
            
            self.walletBalanceHeaderView.hideSkeleton(transition: .crossDissolve(0.5))
            
            if success {
                self.coinPlanCollectionView.reloadData()
                self.setupWalletBalance(currencyType: .coin)
                self.setupWalletBalance(currencyType: .money)
            } else {
                guard let error else { return }
                self.ism_showAlert("Error", message: error)
            }
        }
    }
    
    func setupWalletBalance(currencyType: ISMWalletCurrencyType){
        walletBalanceHeaderView.configureView(balanceData: nil, currencyType: currencyType)
        
        viewModel.getWalletBalance(currencyType: currencyType) { success, error in
            self.coinPlanCollectionView.hideSkeleton(transition: .crossDissolve(0.5))
            if success {
                self.walletBalanceHeaderView.configureView(balanceData: self.viewModel.walletBalance, currencyType: currencyType)
            }
        }
    }
    
    // MARK: - ACTIONS
    
    @objc func closeButtonTapped(){
        self.dismiss(animated: true)
    }
    
    @objc func transactionButtonTapped(_ sender: UIButton){
        let currencyType = ISMWalletCurrencyType(rawValue: sender.tag) ?? .coin
        let viewModel = WalletTransactionViewModel(isometrik: viewModel.isometrik, walletCurrencyType: currencyType)
        let controller = WalletTransactionViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(controller, animated: true)
    }


}
