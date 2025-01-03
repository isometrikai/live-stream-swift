//
//  WalletTransactionTableViewCell.swift
//  
//
//  Created by Appscrip 3Embed on 12/07/24.
//

import UIKit
import IsometrikStream
import SkeletonView

class WalletTransactionTableViewCell: UITableViewCell, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    let transactionTypeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.isSkeletonable = true
        imageView.skeletonCornerRadius = 20
        return imageView
    }()
    
    let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isSkeletonable = true
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = appearance.font.getFont(forTypo: .h8)
        label.isSkeletonable = true
        label.skeletonTextNumberOfLines = 2
        label.lastLineFillPercent = 60
        label.linesCornerRadius = 3
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = appearance.font.getFont(forTypo: .h6)
        label.numberOfLines = 2
        label.isSkeletonable = true
        label.isHiddenWhenSkeletonIsActive = true
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = appearance.font.getFont(forTypo: .h8)
        label.isSkeletonable = true
        label.isHiddenWhenSkeletonIsActive = true
        return label
    }()
    
    lazy var amountLabel: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h5)
        button.setTitleColor(.black, for: .normal)
        button.isSkeletonable = true
        button.skeletonCornerRadius = 5
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
    
    override func prepareForReuse() {
        transactionTypeImage.layer.borderWidth = 0
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        
        isSkeletonable = true
        contentView.isSkeletonable = true
        
        backgroundColor = .clear
        contentView.addSubview(transactionTypeImage)
        contentView.addSubview(infoStackView)
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(subtitleLabel)
        infoStackView.addArrangedSubview(timeLabel)
        
        contentView.addSubview(amountLabel)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            transactionTypeImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            transactionTypeImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            transactionTypeImage.widthAnchor.constraint(equalToConstant: 40),
            transactionTypeImage.heightAnchor.constraint(equalToConstant: 40),
            
            infoStackView.leadingAnchor.constraint(equalTo: transactionTypeImage.trailingAnchor, constant: 8),
            infoStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configureCell(data: ISMWalletTransactionData?, currencyType: ISMWalletCurrencyType){
        guard let data else { return }
        
        let transactionType = ISMWalletTransactionType(rawValue: data.txnType.unwrap)
        
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
        titleLabel.text = "TransactionId: \(obscureTransactionId)"
        
        if let note = data.notes {
            subtitleLabel.text = "\(note)"
        }
        
        switch currencyType {
        case .coin:
            amountLabel.setImage(appearance.images.coin, for: .normal)
            let coinBalance = Int64(data.amount.unwrap)
            amountLabel.setTitle(" \(coinBalance)", for: .normal)
        case .money:
            amountLabel.imageView?.image = nil
            let abbreviatedAmount = Double(data.amount.unwrap).formattedWithSuffix(fractionDigits: 1)
            amountLabel.setTitle("\(data.currency.unwrap) \(abbreviatedAmount)", for: .normal)
        }
        
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
