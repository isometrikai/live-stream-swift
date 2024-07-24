//
//  GoLiveWithViewController+External.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 20/06/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import Foundation

extension GoLiveWithViewController {
    
//    func getUsers(searchString: String){
//        
//        if searchString.count == 0 {
//            
//            self.viewModel.isSearching = false
//            self.followViewModel.offset = -40
//            if self.viewModel.selectedOption == .user {
//                getFollowers(isRefresh: true)
//            }
//            
//            return
//        }
//        self.followViewModel.offset = -40
//        
//        let userId = Utility.getUserid() ?? ""
//        let strUrl = AppConstants.searchFollowers + "?userId=\(userId)&searchText=\(searchString)"
//        
//        print("API \(strUrl)")
//        print("********* Search user")
//        
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//        
//        followViewModel.followServiceCall(strUrl: strUrl, params: [:]) { success, error, canServiceCall in
//            
//            self.viewModel.canServiceCall = canServiceCall
//            MBProgressHUD.hide(for: self.view, animated: true)
//            
//            if success {
//                DispatchQueue.main.async {
//                    self.defaultView.isHidden = true
//                    self.defaultView.defaultLabel.text = ""
//                    self.setFollowerData()
//                }
//            } else if let error = error{
//                if error.code != 204{
////                    Helper.showAlertViewOnWindow(Strings.error.localized, message: (error.localizedDescription))
//                }else if error.code == 204{
//                    DispatchQueue.main.async {
//                        self.followViewModel.followModelArray.removeAll()
//                        self.viewModel.users.removeAll()
//                        self.defaultView.isHidden = false
//                        self.defaultView.defaultLabel.text = "No user found with \"\(searchString)\" "
//                        DispatchQueue.main.async {
//                            self.contentTableView.reloadData()
//                        }
//                    }
//                }
//                self.followViewModel.offset = -40
//            }
//        }
//    }
    
//    func setFollowerData(){
//        
//        self.viewModel.users.removeAll()
//        
//        let followers = self.followViewModel.followModelArray
//
//        if followers.count > 0 {
//            
//            for i in 0..<followers.count {
//                
//                let follower = followers[i]
//                let user = ISMUser(userId: follower.isometrikUserId ?? "", identifier: follower.userName ?? "", name: "\(follower.firstName) \(follower.lastName)", imagePath: follower.profilePic ?? "")
//                
//                self.viewModel.users.append(user)
//                
//                if i == followers.count - 1 {
//                    self.contentTableView.reloadData()
//                }
//                
//            }
//        }
//    }
//    
//    func getFollowers(isRefresh: Bool = false){
//        
//        // hide default empty view when loading data
//        self.defaultView.isHidden = true
//        
//        if isRefresh {
//            self.followViewModel.offset = -40
//            viewModel.users.removeAll()
//            contentTableView.reloadData()
//        }
//        
//        let userID = Utility.getUserid() ?? ""
//        
//        let strURL = AppConstants.getFollowers + "?userId=\(userID)"
//        
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//        
//        followViewModel.followServiceCall(strUrl: strURL, params: [:]) { (success, error, canServiceCall) in
//            
//            MBProgressHUD.hide(for: self.view, animated: true)
//            self.viewModel.canServiceCall = canServiceCall
//            
//            if success {
//                self.defaultView.isHidden = true
//                self.setFollowerData()
//            } else if let error = error {
//                // loader hide
//                if error.code != 204 {
//                    self.defaultView.isHidden = false
//                    self.defaultView.defaultLabel.text = "No User found"
//                }
//                self.defaultView.isHidden = false
//                self.defaultView.defaultLabel.text = "No User found"
//                self.followViewModel.offset = self.followViewModel.offset - 40
//            }
//            
//        }
//        
//    }
    
}
