//
//  BuyPaidStreamViewController.swift
//  
//
//  Created by Appscrip 3Embed on 19/07/24.
//

import UIKit
import IsometrikStream

final public class BuyPaidStreamViewController: UIViewController, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var viewModel: PaidStreamViewModel
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = appearance.font.getFont(forTypo: .h4)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let actionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(appearance.colors.appSecondary, for: .normal)
        button.backgroundColor = appearance.colors.appColor
        button.layer.cornerRadius = 5
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h6)
        button.tag = 1
        button.ismTapFeedBack()
        button.addTarget(self, action: #selector(responseAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(appearance.colors.appSecondary, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h6)
        button.layer.borderWidth = 1.5
        button.tag = 0
        button.layer.borderColor = appearance.colors.appSecondary.withAlphaComponent(0.5).cgColor
        button.ismTapFeedBack()
        button.addTarget(self, action: #selector(responseAction(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - MAIN
    
    public init(viewModel: PaidStreamViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(actionStackView)
        
        actionStackView.addArrangedSubview(cancelButton)
        actionStackView.addArrangedSubview(confirmButton)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            actionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            actionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            actionStackView.heightAnchor.constraint(equalToConstant: 50),
            actionStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30)
        ])
    }
    
    func setupUI(){
        let amountLabel = Int64(viewModel.amountToPay).ism_roundedWithAbbreviations
        titleLabel.text = "Are you sure want to spend" + " \(amountLabel) " + "Coins to watch this stream" + " ?"
    }
    
    // MARK: - ACTIONS
    
    @objc func responseAction(_ sender: UIButton) {
        self.dismiss(animated: true)
        if sender.tag == 1 {
            
            // check for balance
            let balance = UserDefaultsProvider.shared.getWalletBalance(currencyType: WalletCurrencyType.coin.rawValue)
            if !(Int64(balance) > viewModel.amountToPay) {
                self.viewModel.response?(.failed(errorString: "Insufficient Balance!"))
                self.dismiss(animated: true)
                return
            }
            
            CustomLoader.shared.startLoading()
            viewModel.buyStream { (success, errorString) in
                CustomLoader.shared.stopLoading()
                if errorString == nil {
                    self.viewModel.response?(.success)
                } else {
                    self.viewModel.response?(.failed(errorString: errorString.unwrap))
                }
                self.dismiss(animated: true)
            }
        } else {
            self.dismiss(animated: true)
        }
    }

}
