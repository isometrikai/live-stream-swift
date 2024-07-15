//
//  WalletTransactionTableViewCell.swift
//  
//
//  Created by Appscrip 3Embed on 12/07/24.
//

import UIKit
import IsometrikStream

class WalletTransactionTableViewCell: UITableViewCell, ISMStreamUIAppearanceProvider {

    // MARK: - PROPERTIES
    
    let transactionTypeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var transactionId: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = appearance.font.getFont(forTypo: .h6)
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = appearance.font.getFont(forTypo: .h8)
        return label
    }()
    
    lazy var coinAmount: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h5)
        button.setImage(appearance.images.coin, for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    // MARK: MAIN -
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        backgroundColor = .clear
        addSubview(transactionTypeImage)
        addSubview(infoStackView)
        infoStackView.addArrangedSubview(transactionId)
        infoStackView.addArrangedSubview(timeLabel)
        
        addSubview(coinAmount)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            transactionTypeImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            transactionTypeImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            transactionTypeImage.widthAnchor.constraint(equalToConstant: 40),
            transactionTypeImage.heightAnchor.constraint(equalToConstant: 40),
            
            infoStackView.leadingAnchor.constraint(equalTo: transactionTypeImage.trailingAnchor, constant: 8),
            infoStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            coinAmount.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            coinAmount.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configureCell(data: WalletTransactionData?){
        guard let data else { return }
        
        let transactionType = WalletTransactionType(rawValue: data.txnType.unwrap)
        
        switch transactionType {
        case .debit:
            transactionTypeImage.image = appearance.images.debitTransaction
            transactionTypeImage.layer.borderWidth = 2
            transactionTypeImage.layer.borderColor = appearance.colors.appRed.cgColor
            break
        case .credit:
            transactionTypeImage.image = appearance.images.creditTransaction
            transactionTypeImage.layer.borderWidth = 2
            transactionTypeImage.layer.borderColor = appearance.colors.appGreen.cgColor
        default:
            break
        }
        
        let obscureTransactionId = obscureString(data.transactionId.unwrap)
        transactionId.text = "TransactionId: \(obscureTransactionId)"
        
        coinAmount.setTitle("  \(data.amount.unwrap)", for: .normal)
        
        let timeStampInSec = TimeInterval(Double(data.txnTimeStamp.unwrap) / 1000)
        let date = Date(timeIntervalSince1970: timeStampInSec)
        let formattedString = date.ism_toString(format: "dd MMMM yyyy, hh:mma")
        
        timeLabel.text = "\(formattedString)"
    }
    
    func obscureString(_ originalString: String) -> String {
        // Define the number of characters to keep at the start and end
        let prefixLength = 5 // "txn-e"
        let suffixLength = 4 // "acde"
        let obscuring = "****"
        
        // Check if the original string is long enough
        guard originalString.count > prefixLength + suffixLength else {
            return originalString
        }
        
        // Extract the prefix
        let prefixEndIndex = originalString.index(originalString.startIndex, offsetBy: prefixLength)
        let prefix = originalString[..<prefixEndIndex]
        
        // Extract the suffix
        let suffixStartIndex = originalString.index(originalString.endIndex, offsetBy: -suffixLength)
        let suffix = originalString[suffixStartIndex...]
        
        // Construct the obscured string
        let obscuredString = prefix + obscuring + suffix
        
        return String(obscuredString)
    }

}
