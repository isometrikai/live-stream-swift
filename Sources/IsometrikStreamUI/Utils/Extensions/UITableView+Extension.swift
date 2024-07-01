//
//  UITableView+Extension.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 14/09/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

extension UITableView {
    
    func isValid(indexPath: IndexPath) -> Bool {
        guard indexPath.section < numberOfSections,
              indexPath.row < numberOfRows(inSection: indexPath.section)
        else { return false }
        return true
    }
    
    var contentSizeHeight: CGFloat {
        var height = CGFloat(0)
        for section in 0..<numberOfSections {
            height = height + rectForHeader(inSection: section).height
            let rows = numberOfRows(inSection: section)
            for row in 0..<rows {
                height = height + rectForRow(at: IndexPath(row: row, section: section)).height
            }
        }
        return height
    }
    
    
}
