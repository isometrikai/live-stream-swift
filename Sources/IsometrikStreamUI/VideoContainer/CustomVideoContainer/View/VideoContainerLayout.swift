//
//  VideoContainerLayout.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 31/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

public class VideoContainerLayout {
    
    static let shared = VideoContainerLayout()
    
    func getLayout(withVideoSession videoSessions: Int) -> NSCollectionLayoutSection? {
        switch videoSessions {
            case 1:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))

                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
                
            case 2:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                let estimatedH = (UIScreen.main.bounds.width / 2) * (4/3)

                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1/2), heightDimension: .absolute(estimatedH)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                
                return section
                
            default:
                
                let estimatedH = (UIScreen.main.bounds.width / 3) * (4/3)
            
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1)))

                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(estimatedH)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
        }
    }
    
    func getRTMPLayout(withVideoSession videoSessions: Int) -> NSCollectionLayoutSection? {
        
        let inset: CGFloat = 0
        
        let estimatedHForLargeItem = (UIScreen.main.bounds.width) * (9/16)
        let estimatedHForSmallItem = (UIScreen.main.bounds.width / 4) * (4/3)
        let totalH = estimatedHForLargeItem + estimatedHForSmallItem
        
        // Items
        let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(estimatedHForLargeItem))
        let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
        largeItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let smallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/4), heightDimension: .fractionalHeight(1))
        let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
        smallItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 0)
        
        // Nested Group
        let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(estimatedHForSmallItem))
        let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: nestedGroupSize, subitems: [smallItem])
        nestedGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 2)
        
        // Outer Group
        let outerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(totalH))
        let outerGroup = NSCollectionLayoutGroup.vertical(layoutSize: outerGroupSize, subitems: [largeItem, nestedGroup])
        
        // Section
        let section = NSCollectionLayoutSection(group: outerGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
         
        return section
        
    }
    
}

