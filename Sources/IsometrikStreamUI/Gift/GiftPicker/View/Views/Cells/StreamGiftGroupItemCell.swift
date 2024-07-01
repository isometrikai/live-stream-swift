//
//  StreamGiftGroupItemCell.swift
//  PicoAdda
//
//  Created by Appscrip 3Embed on 12/03/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

class StreamGiftGroupItemCell: UICollectionViewCell {
    
    // MARK: - PROPERTIES
    
    var data: ISMStreamGiftModel? {
        didSet {
            manageData()
        }
    }
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let giftItemImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let groupItemTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "12 Coins"
        label.font = Appearance.default.font.getFont(forTypo: .h8)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: MAIN -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        addSubview(cardView)
        cardView.addSubview(giftItemImage)
        cardView.addSubview(groupItemTitle)
    }
    
    func setUpConstraints(){
        cardView.pin(to: self)
        NSLayoutConstraint.activate([
            giftItemImage.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            giftItemImage.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            giftItemImage.widthAnchor.constraint(equalToConstant: 50),
            giftItemImage.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -25),
            
            groupItemTitle.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            groupItemTitle.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            groupItemTitle.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -5)
        ])
    }
    
    func manageData(){
        guard let data else { return }
        groupItemTitle.text = "\(data.virtualCurrency ?? 0) Coins"
        
        if let imgString = data.giftImage, imgString != "", let imageUrl = URL(string: imgString) {
            giftItemImage.kf.setImage(with: imageUrl)
        } else {
            giftItemImage.image = UIImage()
            giftItemImage.backgroundColor = .lightGray.withAlphaComponent(0.5)
        }
    }
}
