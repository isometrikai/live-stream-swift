//
//  AllProductViewController+Delegate.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 25/10/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit


extension AllProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let productViewModel else { return Int() }
        return productViewModel.getDataCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let productViewModel else { return UITableViewCell() }
        
        if productViewModel.myStore {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListTableViewCell", for: indexPath) as! ProductListTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.tag = indexPath.row
            cell.contentView.isUserInteractionEnabled = false
            cell.myStore = true
            cell.isOfferEditable = productViewModel.isOfferEditable
            
            let productList = productViewModel.productList
            if productList.count > 0 {
                let productData = productList[indexPath.row]
                cell.productData = productData
            }
        
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreListTableViewCell", for: indexPath) as! StoreListTableViewCell
            cell.selectionStyle = .none
            cell.contentView.isUserInteractionEnabled = false
            
            let storeList = productViewModel.storesList
            if storeList.count > 0 {
                let storeData = storeList[indexPath.row]
                cell.data = storeData
            }
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let productViewModel else { return }
        
        if productViewModel.myStore {
            let productList = productViewModel.productList
            if !(productList.count > 0) {
                return
            }
            
            let isSelected = productList[indexPath.row].isSelected
            var productData = productList[indexPath.row]
            
            productViewModel.productList[indexPath.row].isSelected = !isSelected
            productViewModel.productList[indexPath.row].liveStreamfinalPriceList?.discountPercentage = 0
            
            productData = productViewModel.productList[indexPath.row]
            
            // add or remove product to the list
            productViewModel.updateSelectedProducts(productData: productData) {
                self.productTableView.reloadData()
                // update UI after product selection
                self.updateSelectedProductView()
            }
            
            self.productTableView.reloadData()
        } else {
            
            let storeList = productViewModel.storesList
            if !(storeList.count > 0) {
                return
            }
            
            let storeData = storeList[indexPath.row]
            let storeId = storeData.id ?? ""
            let storeTitle = storeData.storeName
            
            let controller = StoreProductListViewController()
            controller.productViewModel = productViewModel
            controller.storeId = storeId
            controller.storeTitle = storeTitle
            
            // callback for continue button
            controller.continue_callback = { [weak self] in
                self?.updateSelectedProductView()
            }
            
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let productViewModel else { return 0 }
        if productViewModel.myStore {
            return 100
        } else {
            return 70
        }
    }
    
}

extension AllProductsViewController: ProductListActionDelegate {
    
    func didActionButtonTapped(index: Int) {
        
        guard let productViewModel else { return }
        
        let isOfferEditable = productViewModel.isOfferEditable
        let productList = productViewModel.productList
        if !(productList.count > 0) {
            return
        }
        
        let discountedPercentage = productList[index].liveStreamfinalPriceList?.discountPercentage ?? 0
        var productData = productViewModel.productList[index]
        
        if isOfferEditable {
            
            let controller = ProductDetailsViewController()
            controller.modalPresentationStyle = .pageSheet
            
            if #available(iOS 15.0, *) {
                if #available(iOS 16.0, *) {
                    controller.sheetPresentationController?.prefersGrabberVisible = false
                    controller.sheetPresentationController?.detents = [
                        .custom(resolver: { context in
                            return 250 + ism_windowConstant.getBottomPadding
                        })
                    ]
                }
            }
            
            controller.productViewModel = productViewModel
            controller.productData = productData
            controller.editableDiscountPercentage = discountedPercentage
            
            controller.addCallback = { [weak self] discountedPercentage in
                
                guard let self else { return }
                
                var productData = productViewModel.productList[index]
                productData.liveStreamfinalPriceList?.discountPercentage = discountedPercentage ?? 0.0
                productViewModel.productList[index] = productData
                productViewModel.updateSelectedProducts(productData: productData) {
                    self.productTableView.reloadData()
                    // update UI after product selection
                    self.updateSelectedProductView()
                }
                
            }
            
            self.present(controller, animated: true)
            return
            
        } else if discountedPercentage != 0  {
            
            productData.liveStreamfinalPriceList?.discountPercentage = 0
            productViewModel.productList[index] = productData
            productViewModel.updateSelectedProducts(productData: productData) {
                self.productTableView.reloadData()
                // update UI after product selection
                self.updateSelectedProductView()
            }
            
        } else {
            
            let controller = ProductDetailsViewController()
            controller.modalPresentationStyle = .pageSheet
            
            if #available(iOS 15.0, *) {
                if #available(iOS 16.0, *) {
                    controller.sheetPresentationController?.prefersGrabberVisible = false
                    controller.sheetPresentationController?.detents = [
                        .custom(resolver: { context in
                            return 250 + ism_windowConstant.getBottomPadding
                        })
                    ]
                }
            }
            
            controller.addCallback = { [weak self] discountedPercentage in
                
                guard let self else { return }
                
                productData.liveStreamfinalPriceList?.discountPercentage = discountedPercentage ?? 0.0
                productViewModel.productList[index] = productData
                productViewModel.updateSelectedProducts(productData: productData) {
                    self.productTableView.reloadData()
                    // update UI after product selection
                    self.updateSelectedProductView()
                }
                
            }
            
            self.present(controller, animated: true)
            return
        }
    }
    
}

extension AllProductsViewController: SelectedProductActionDelegate {
    
    func didProductRemoved(with index: Int) {
        
        guard let productViewModel else { return }
        
        let selectedProductList = productViewModel.selectedProductList
        if !(selectedProductList.count > 0) {
            return
        }
        
        if isFromLive {
            
            let productData = selectedProductList[index]
            productViewModel.handleProductToRemove(productData)
            
        } else {
            // nothing
        }
            
        productViewModel.selectedProductList[index].isSelected = false
        
        let productData = productViewModel.selectedProductList[index]
        
        let group = DispatchGroup()
        
        group.enter()
        // update selected flag in productList if product exist
        productViewModel.unselectProductFromProductList(productData: productData) {
            group.leave()
        }
        
        group.notify(queue: .main) {
            
            // add or remove product to the list
            productViewModel.updateSelectedProducts(productData: productData) {
                self.productTableView.reloadData()
                // update UI after product selection
                self.updateSelectedProductView()
            }
            
            self.productTableView.reloadData()
            
        }
        
    }
    
}
