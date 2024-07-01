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
    
}

