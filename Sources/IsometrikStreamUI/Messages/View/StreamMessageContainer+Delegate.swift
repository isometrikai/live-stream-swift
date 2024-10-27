//
//  StreamMessageContainer+Delegate.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 13/09/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

extension StreamMessageContainer: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel else { return Int() }
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let viewModel else { return UITableViewCell() }
        
        let message = viewModel.messages[indexPath.row]
        let userAccess = viewModel.streamUserAccess
        let messageType = ISMStreamMessageType(rawValue: Int(message.messageType ?? 0))
        
        switch messageType {
            
        case .deletedMessage:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "StreamDeleteMessageTableViewCell", for: indexPath) as! StreamDeleteMessageTableViewCell
            cell.selectionStyle = .none
            cell.data = message
            
            return cell
            
        case .text, .productBought:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "StreamMessageTableViewCell", for: indexPath) as! StreamMessageTableViewCell
            cell.selectionStyle = .none
            cell.deleteButton.tag = indexPath.row
            cell.profileButton.tag = indexPath.row
            cell.contentView.isUserInteractionEnabled = false
            
            let message = viewModel.messages[indexPath.row]
            cell.configureData(message: message, userAccess: userAccess)
            cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
            cell.profileButton.addTarget(self, action: #selector(profileButtonTapped(_:)), for: .touchUpInside)
            return cell
            
        case .request:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StreamRequestMessageTableViewCell", for: indexPath) as! StreamRequestMessageTableViewCell
            cell.selectionStyle = .none
            let message = viewModel.messages[indexPath.row]
            cell.configureCell(message: message)
            cell.acceptButton.tag = indexPath.row
            cell.rejectButton.tag = indexPath.row
            cell.acceptButton.addTarget(self, action: #selector(acceptButtonTapped(_:)), for: .touchUpInside)
            cell.rejectButton.addTarget(self, action: #selector(rejectButtonTapped(_:)), for: .touchUpInside)
            cell.contentView.isUserInteractionEnabled = false
            return cell
            
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let viewModel else { return 0 }
        
        let message = viewModel.messages[indexPath.row]
        let messageType = ISMStreamMessageType(rawValue: Int(message.messageType ?? 0))
        
        switch messageType {
        case .productBought, .deletedMessage, .text , .request :
            return messageTableView.estimatedRowHeight
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let viewModel else { return }
        if viewModel.messages.count > 20 {
            if indexPath.row == 0 {
                delegate?.loadMoreMessages()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let viewModel else { return }
        
        if indexPath.row + 1 == viewModel.messages.count {
            // sends delegate to inform reached to bottom of tableView
            delegate?.didMessageScrolled(withStatus: .reachedBottom)
            
        } else {
            // sends delegate to inform not reached to bottom of tableView yet
            delegate?.didMessageScrolled(withStatus: .notReachedBottom)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYOffset

        if distanceFromBottom - 20 < height {
            print("You reached end of the table")
            self.scrollToBottomButton.isHidden = true
        } else {
            self.scrollToBottomButton.isHidden = false
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // send delegate to disable outer scrollView scrolling
        delegate?.didMessageScrolled(withStatus: .started)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // send delegate to enable scrolling for outer scrollView
        delegate?.didMessageScrolled(withStatus: .ended)
    }
    
}
