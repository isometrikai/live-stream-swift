//
//  GoLiveWithViewController+Delegate.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 19/06/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

extension GoLiveWithViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCellCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if viewModel.selectedOption == .user {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StreamMemberTableViewCell", for: indexPath) as! StreamMemberTableViewCell
            configureUserCell(cell: cell)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StreamViewerTableViewCell", for: indexPath) as! StreamViewerTableViewCell
            configureViewerCell(cell: cell)
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

extension GoLiveWithViewController {
    
    func configureViewerCell(cell: UITableViewCell){
        guard let cell = cell as? StreamViewerTableViewCell,
              let indexPath = self.contentTableView.indexPath(for: cell)
        else { return }
        
        cell.actionType = .add
        cell.isometrik = viewModel.isometrik
        cell.data = viewModel.viewers[indexPath.row]
        cell.actionType = .add
        
        cell.selectionStyle = .none
        cell.tag = indexPath.row
        cell.delegate = self
        cell.contentView.isUserInteractionEnabled = false
    }
    
    func configureUserCell(cell: UITableViewCell){
        
        guard let cell = cell as? StreamMemberTableViewCell,
              let indexPath = self.contentTableView.indexPath(for: cell)
        else { return }
        
        cell.tag = indexPath.row
        cell.statusView.isHidden = true
        cell.isometrik = viewModel.isometrik
        cell.isGoLiveWith = true
        cell.delegate = self
        cell.contentView.isUserInteractionEnabled = false

        let user = viewModel.users[indexPath.row]
        
        let userId = user.userId.unwrap
        let userName = user.name.unwrap
        let userIdentifier = user.identifier.unwrap
        let userProfileImageUrl = user.imagePath.unwrap
        let isPublishing = false
        let isAdmin = false
        
        let member = ISMMember(
            userID: userId,
            userName: userName,
            userProfileImageURL: userProfileImageUrl,
            userIdentifier: userIdentifier,
            isPublishing: isPublishing,
            isAdmin: isAdmin
        )
        
        cell.configureCell(member: member)
        
        if !viewModel.isSearching {
            if indexPath.row == self.viewModel.users.count - 1 { // last cell
                if self.viewModel.canServiceCall { // more items to fetch
                    self.viewModel.canServiceCall = false
                    //getFollowers()
                }
            }
        }
        
    }
    
}

extension GoLiveWithViewController: StreamViewerActionDelegate, StreamMemberListActionDelegate {
    func updateViewers(viewers: [ISMViewer]) {
        
    }
    
    func didActionButtonTapped(with index: Int, with data: ISMViewer, actionType: ActionType) {
        switch actionType {
        case .add:
            self.addViewerAsMember(data, index)
            break
        case .kickout:
            // nothing
            break
        }
    }
    
    func didViewerTapped(with user: ISMViewer?, navigationController: UINavigationController?) {
        
    }
    
    func didAddMemberTapped(member: ISMMember, index: Int) {
        
        // Hitting API for adding member
        viewModel.addMember(userId: member.userID.unwrap) { result in
            
            switch result {
            case .success:
                
                // Updating UI
                let isSearching = self.viewModel.isSearching
                self.viewModel.users.remove(at: index)
                
                self.contentTableView.beginUpdates()
                let indexPath = IndexPath(row: index, section: 0)
                self.contentTableView.deleteRows(at: [indexPath] , with: .fade)
                self.contentTableView.endUpdates()
                
                self.contentTableView.reloadData()
                
                break
            case .failure(let msg):
                self.view.showISMLiveErrorToast( message: msg)
         
            }
            
        }
        
    }
    
    func addViewerAsMember(_ viewerData: ISMViewer, _ index: Int) {
        viewModel.addMember(userId: viewerData.viewerId.unwrap) { result in
            
            switch result {
            case .success:
                
                // Updating UI
                self.viewModel.viewers.remove(at: index)
                
                self.contentTableView.beginUpdates()
                let indexPath = IndexPath(row: index, section: 0)
                self.contentTableView.deleteRows(at: [indexPath] , with: .fade)
                self.contentTableView.endUpdates()
                
                self.contentTableView.reloadData()
                
                break
            case .failure(let msg):
                self.view.showISMLiveErrorToast( message: msg)
            }
            
        }
        
    }
    
}
