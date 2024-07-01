//
//  StreamGiftContentItemsView.swift
//  PicoAdda
//
//  Created by Appscrip 3Embed on 12/03/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

protocol StreamGiftItemActionProtocol {
    func callForNextPage(groupId: String)
    func didGiftItemSelected(giftData: ISMStreamGiftModel)
}

class StreamGiftContentItemsView: UIView, AppearanceProvider {

    // MARK: - PROPERTIES
    
    var totalCount = 0
    var data: [ISMStreamGiftModel] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    var delegate: StreamGiftItemActionProtocol?
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(StreamGiftGroupItemCell.self, forCellWithReuseIdentifier: "StreamGiftGroupItemCell")
        collectionView.backgroundColor = .clear
        collectionView.delaysContentTouches = false
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        return collectionView
    }()
    
    lazy var defaultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No Gifts Found"
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h8)
        label.textAlignment = .center
        label.isHidden = true
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
        addSubview(collectionView)
        addSubview(defaultLabel)
    }
    
    func setUpConstraints(){
        collectionView.ism_pin(to: self)
        NSLayoutConstraint.activate([
            defaultLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            defaultLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}


extension StreamGiftContentItemsView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StreamGiftGroupItemCell", for: indexPath) as! StreamGiftGroupItemCell
        cell.data = data[indexPath.row]
        
        if indexPath.row == data.count - 1 {
            if data.count < totalCount {
                if let groupData = data[safe: indexPath.row], let groupId = groupData.giftGroupId {
                    delegate?.callForNextPage(groupId: groupId)
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard data.count > 0,
              let giftData = data[safe: indexPath.row]
        else { return }
        delegate?.didGiftItemSelected(giftData: giftData)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width) / 4 , height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? StreamGiftGroupItemCell {
            UIView.animate(withDuration: 0.3) {
                cell.cardView.transform = .init(scaleX: 0.95, y: 0.95)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? StreamGiftGroupItemCell {
            UIView.animate(withDuration: 0.3) {
                cell.cardView.transform = .identity
            }
        }
    }
    
}
