//
//  StoreProductListViewController+Delegate.swift
//  Shopr
//
//  Created by new user on 30/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

extension StoreProductListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let productViewModel else { return Int() }
        return productViewModel.storeProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let productViewModel else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListTableViewCell", for: indexPath) as! ProductListTableViewCell
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        cell.tag = indexPath.row
        cell.contentView.isUserInteractionEnabled = false
        
        cell.myStore = false
        
        let productList = productViewModel.storeProductList
        let storeProductCount = productViewModel.storeProductsTotalCount
        
        if productList.count > 0 {
            let productData = productList[indexPath.row]
            cell.productData = productData
        }
        
        // for pagination
        if storeProductCount > productList.count, indexPath.row == productList.count - 1 {
            loadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let productViewModel,
        let cell = tableView.cellForRow(at: indexPath) as? ProductListTableViewCell else { return }

        cell.actionButton.isHidden = true
        
        let productList = productViewModel.storeProductList
        if !(productList.count > 0) {
            return
        }
        
        let isSelected = productList[indexPath.row].isSelected
        var productData = productList[indexPath.row]
        productViewModel.storeProductList[indexPath.row].isSelected = !isSelected
        productData = productViewModel.storeProductList[indexPath.row]
        
        productViewModel.updateSelectedStoreProductList(productData: productData) {
            self.updateSelectionUI()
            self.storeProductListTableview.reloadData()
        }
        
        self.storeProductListTableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
