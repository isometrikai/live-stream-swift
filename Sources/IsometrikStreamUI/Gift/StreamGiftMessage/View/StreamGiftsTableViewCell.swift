//
//  StreamGiftsTableViewCell.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 12/04/22.
//

import UIKit
import Kingfisher
import IsometrikStream

class StreamGiftsTableViewCell: UITableViewCell, AppearanceProvider {

    // MARK: - PROPERTIES
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerCurve = .continuous
        view.layer.maskedCorners = [.layerMinXMaxYCorner , .layerMinXMinYCorner]
        return view
    }()
    
    let cardGradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var userDefaultProfile: CustomDefaultProfileView = {
        let imageView = CustomDefaultProfileView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        imageView.layer.borderWidth = 0.7
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        imageView.initialsText.font = appearance.font.getFont(forTypo: .h8)
        return imageView
    }()
    
    let userProfile: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        imageView.layer.borderWidth = 0.7
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let infoStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h8)
        return label
    }()
    
    let coinStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 3
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var coinImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = appearance.images.gift
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var coinLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h8)
        return label
    }()
    
    let giftImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    // MARK: - MAIN
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupContraints()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.cardGradientView.ism_setGradient(withColors: [self.appearance.colors.appColor.cgColor, self.appearance.colors.appColor.withAlphaComponent(0.5).cgColor, UIColor.white.withAlphaComponent(0).cgColor], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 0))
            self.cardView.layer.cornerRadius = self.cardView.frame.height / 2
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        backgroundColor = .clear
        addSubview(cardView)
        
        cardView.addSubview(cardGradientView)
        cardView.addSubview(userDefaultProfile)
        cardView.addSubview(userProfile)
        
        cardView.addSubview(infoStack)
        
        infoStack.addArrangedSubview(userNameLabel)
        infoStack.addArrangedSubview(coinStack)
        
        coinStack.addArrangedSubview(coinLabel)
        coinStack.addArrangedSubview(coinImage)
        
        addSubview(giftImage)
        
    }
    
    func setupContraints(){
        cardGradientView.ism_pin(to: cardView)
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
            
            userDefaultProfile.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 3),
            userDefaultProfile.widthAnchor.constraint(equalToConstant: 30),
            userDefaultProfile.heightAnchor.constraint(equalToConstant: 30),
            userDefaultProfile.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            
            userProfile.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 3),
            userProfile.widthAnchor.constraint(equalToConstant: 30),
            userProfile.heightAnchor.constraint(equalToConstant: 30),
            userProfile.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            
            infoStack.leadingAnchor.constraint(equalTo: userProfile.trailingAnchor, constant: 5),
            infoStack.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            
            coinImage.widthAnchor.constraint(equalToConstant: 10),
            coinImage.heightAnchor.constraint(equalToConstant: 10),
            
            giftImage.leadingAnchor.constraint(equalTo: infoStack.trailingAnchor, constant: 20),
            giftImage.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            giftImage.widthAnchor.constraint(equalToConstant: 30),
            giftImage.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configureData(messageInfo: ISMComment, viewType: UserType = .host, user: ISMStreamUser){
        
        guard let senderName = messageInfo.senderName,
              let profileImage = messageInfo.senderImage,
              let messageType = messageInfo.messageType
        else { return }
        
        if ISMStreamMessageType(rawValue: Int(messageType)) == .giftMessage {
            
            userNameLabel.text = senderName
            if profileImage != UserDefaultsProvider.shared.getIsometrikDefaultProfile() {
                //userProfile.kf.setImage(with: profileImage)
            } else {
                userProfile.image = UIImage()
            }
            
            let initialText = senderName.prefix(2).uppercased()
            userDefaultProfile.initialsText.text = initialText
            
            guard let data = messageInfo.message?.data(using: String.Encoding.utf8),
                  let giftModel = try? JSONDecoder().decode(StreamMessageGiftModel.self, from: data) else { return }
            
            print("GIFT Image : \(giftModel.message ?? "")")
            let giftMessage = giftModel.message.unwrap
            
            let recieverName = (giftModel.receiverName.unwrap).ism_trunc(length: 10)
                
            coinLabel.text = "sent".ism_localized + ", \(recieverName) : " + " \(giftModel.coinsValue ?? 0) " + "coins".ism_localized
            
            //self.giftImage.kf.setImage(with: giftMessage)
            
        }
    }
    
    func getUserName(with id: String) -> String {
        
//        if let memberDetails = self.streamInfo?.members {
//            for i in 0..<memberDetails.count {
//                let member = memberDetails[i]
//                if member.memberId == id {
//                    return member.identifier ?? ""
//                }
//            }
//        }
        return ""
        
    }
}
