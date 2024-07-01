//
//  StreamUserProfileViewController+Delegate.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 09/02/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import UIKit

extension StreamUserProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return streamUserProfileOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StreamUserProfileOptionTableViewCell", for: indexPath) as! StreamUserProfileOptionTableViewCell
        cell.selectionStyle = .none
        cell.optionData = streamUserProfileOptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let messageData else { return }
        let actionType = streamUserProfileOptions[indexPath.row].actionType
        self.dismiss(animated: true)
        delegate?.didUserProfileOptionTapped(actionType: actionType, messageData: messageData)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? StreamUserProfileOptionTableViewCell {
            UIView.animate(withDuration: 0.2) {
                cell.contentView.backgroundColor = .gray.withAlphaComponent(0.2)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? StreamUserProfileOptionTableViewCell {
            UIView.animate(withDuration: 0.2) {
                cell.contentView.backgroundColor = .clear
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}

