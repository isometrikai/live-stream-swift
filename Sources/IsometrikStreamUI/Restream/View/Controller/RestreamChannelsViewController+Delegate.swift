//
//  RestreamChannelsViewController+Delegate.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 12/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import Foundation

extension RestreamChannelsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.restreamChannels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestreamOptionTableViewCell", for: indexPath) as! RestreamOptionTableViewCell
        cell.restreamData = viewModel.restreamChannels[indexPath.row]
        cell.tag = indexPath.row
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let restreamChannelData = viewModel.restreamChannels[safe: indexPath.row] else { return }
        
        let controller = RestreamChannelDetailViewController()
        controller.restreamViewModel = self.viewModel
        controller.restreamChannelData = restreamChannelData
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? RestreamOptionTableViewCell {
            UIView.animate(withDuration: 0.3) {
                cell.backgroundColor = .lightGray.withAlphaComponent(0.3)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? RestreamOptionTableViewCell {
            UIView.animate(withDuration: 0.3) {
                cell.backgroundColor = .clear
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
