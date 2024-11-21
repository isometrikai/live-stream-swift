//
//  StreamGiftGroupCell.swift
//  PicoAdda
//
//  Created by Appscrip 3Embed on 12/03/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import UIKit
import Kingfisher
import IsometrikStream
import SkeletonView

class StreamGiftGroupCell: UICollectionViewCell, ISMAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    override var isSelected: Bool {
        didSet {
            dividerView.isHidden = isSelected ? false : true
            groupTitle.textColor = isSelected ? .white : .lightGray.withAlphaComponent(0.5)
        }
    }
    
    var data: ISMStreamGiftModel? {
        didSet {
            manageData()
        }
    }
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isSkeletonable = true
        return view
    }()
    
    let giftGroupImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isSkeletonable = true
        imageView.skeletonCornerRadius = 2
        imageView.backgroundColor = .white.withAlphaComponent(0.1)
        return imageView
    }()
    
    lazy var groupTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray.withAlphaComponent(0.5)
        label.text = "Group name"
        label.font = appearance.font.getFont(forTypo: .h8)
        label.textAlignment = .center
        label.isSkeletonable = true
        label.skeletonTextLineHeight = .fixed(3)
        return label
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.isHidden = true
        return view
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
        
        isSkeletonable = true
        contentView.isSkeletonable = true
        
        contentView.addSubview(cardView)
        cardView.addSubview(giftGroupImage)
        cardView.addSubview(groupTitle)
        contentView.addSubview(dividerView)
    }
    
    func setUpConstraints(){
        cardView.ism_pin(to: self)
        NSLayoutConstraint.activate([
            giftGroupImage.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            giftGroupImage.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            giftGroupImage.widthAnchor.constraint(equalToConstant: 50),
            giftGroupImage.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -25),
            
            groupTitle.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            groupTitle.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            groupTitle.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -5),
            
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func manageData(){
        guard let data else { return }
        groupTitle.text = data.giftTitle.unwrap
        
        if let imgString = data.giftImage, imgString != "", let imageUrl = URL(string: imgString) {
            giftGroupImage.kf.setImage(with: imageUrl)
        } else {
            giftGroupImage.image = appearance.images.giftPlaceholder
        }
    }
    
}
