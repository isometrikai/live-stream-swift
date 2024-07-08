//
//  StreamLiveViewController+Moderator+Actions.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 14/02/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

extension StreamViewController: StreamModeratorsListActionDelegate {
    
    func handleModalActions(_ title: String? = nil , _ subtitle: String? = nil, joinAsCopublisher: Bool = false){
        
        // get user type
        let userType = viewModel.streamUserType
        
        let controller = StreamDynamicPopupViewController()
        
        // configurations
        switch userType {
        case .member:
            // not require
            break
        case .viewer:
            
            if joinAsCopublisher {
                
                controller.titleLabel.text = title ?? ""
                controller.infoLabel.text =  subtitle ?? ""
                controller.infoLabel.font = appearance.font.getFont(forTypo: .h8)
                controller.infoLabel.textColor = .lightGray
                
                controller.cancelButton.setTitle("Cancel".localized, for: .normal)
                controller.actionButton.setTitle("Join".localized, for: .normal)
                
            } else {
                controller.titleLabel.text = title ?? ""
                controller.infoLabel.text =  subtitle ?? ""
                controller.infoLabel.font = appearance.font.getFont(forTypo: .h8)
                controller.infoLabel.textColor = .lightGray
                
                controller.cancelButton.setTitle("Got It".localized, for: .normal)
                controller.actionStackView.ism_removeFully(view: controller.actionButton)
                controller.actionButton.isHidden = true
            }
            
            break
        case .host:
            
            controller.titleLabel.text = "You're currently moderating the broadcast".localized
            controller.infoLabel.text = "Being a moderator you can kickout members and viewers, reply to and delete messages".localized + "."
            controller.infoLabel.font = appearance.font.getFont(forTypo: .h8)
            controller.infoLabel.textColor = .lightGray
            
            controller.cancelButton.setTitle("Got It".localized, for: .normal)
            controller.actionButton.setTitle("Manage Moderators".localized, for: .normal)
            
            break
        case .moderator:
            
            controller.titleLabel.text = title ?? "You're currently moderating the broadcast".localized
            controller.infoLabel.text = subtitle ?? "Being a moderator you can kickout members and viewers, reply to and delete messages".localized + "."
            controller.infoLabel.font = appearance.font.getFont(forTypo: .h8)
            controller.infoLabel.textColor = .lightGray
            
            controller.cancelButton.setTitle("Got It".localized, for: .normal)
            controller.actionButton.setTitle("Stop Moderating".localized, for: .normal)
            
            break
        }
        
        controller.action_callback = { [weak self] data in
            
            guard let self = self else { return }
            
            controller.dismiss(animated: true)
            if data == .cancel { return }
            
            switch userType {
            case .member:
                // not require
                break
            case .viewer:
                break
            case .host:
                self.openModeratorsListInStream()
                break
            case .moderator:
                self.stopModerating()
                break
            }
            
        }
        
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true)
    }
    
    func openModeratorsListInStream(){
        
        guard let isometrik = viewModel.isometrik,
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let viewModel = ModeratorViewModel(streamInfo: streamData, isometrik: isometrik)
        viewModel.delegate = self
        
        let controller = StreamModeratorsListViewController(viewModel: viewModel)
        controller.modalPresentationStyle = .pageSheet
        
        if let sheet = controller.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return context.maximumDetentValue * 0.6
            }
            sheet.detents = [customDetent]
            sheet.selectedDetentIdentifier = customDetent.identifier
        }
        
        present(controller, animated: true, completion: nil)
        
    }
    
    func openListForSelectingModerators(){
        
        guard let isometrik = viewModel.isometrik,
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let viewModel = ModeratorViewModel(streamInfo: streamData, isometrik: isometrik)
        viewModel.change_callback = { [weak self] in
            guard let self else { return }
            self.openModeratorsListInStream()
        }
        
        let controller = AddModeratorListViewController(viewModel: viewModel)
        
        controller.modalPresentationStyle = .pageSheet
        
        if let sheet = controller.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return context.maximumDetentValue * 0.7
            }
            sheet.detents = [customDetent]
            sheet.selectedDetentIdentifier = customDetent.identifier
        }
        
        present(controller, animated: true, completion: nil)
        
    }
    
    func stopModerating(){
        
        guard let isometrik = viewModel.isometrik,
              let streamsData = viewModel.streamsData,
              let streamData = streamsData[safe: viewModel.selectedStreamIndex.row]
        else { return }
        
        let userId = isometrik.getUserSession().getUserId()
        
        isometrik.getIsometrik().stopModerating(streamId: streamData.streamId ?? "", moderatorId: userId) { moderator in
            print(moderator)
        } failure: { error in
            print(error)
        }
        
    }
    
}
