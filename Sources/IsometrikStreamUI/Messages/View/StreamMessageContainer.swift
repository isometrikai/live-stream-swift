//
//  StreamMessageContainer.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 13/09/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

class StreamMessageContainer: UIView, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var viewModel: StreamMessageViewModel?
    var delegate: StreamCellActionDelegate?
    
    lazy var messageTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(StreamMessageTableViewCell.self, forCellReuseIdentifier: "StreamMessageTableViewCell")
        tableView.register(StreamDeleteMessageTableViewCell.self, forCellReuseIdentifier: "StreamDeleteMessageTableViewCell")
        tableView.register(StreamRequestMessageTableViewCell.self, forCellReuseIdentifier: "StreamRequestMessageTableViewCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var scrollToBottomButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.arrowDown.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .black
        button.backgroundColor = appearance.colors.appColor
        button.layer.cornerRadius = 17.5
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.ismTapFeedBack()
        button.isHidden = true
        button.addTarget(self, action: #selector(scrollToBottom), for: .touchUpInside)
        return button
    }()
    
    // MARK: - MAIN
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        addSubview(messageTableView)
        addSubview(scrollToBottomButton)
    }
    
    func setupConstraints(){
        messageTableView.ism_pin(to: self)
        NSLayoutConstraint.activate([
            scrollToBottomButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            scrollToBottomButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            scrollToBottomButton.widthAnchor.constraint(equalToConstant: 70),
            scrollToBottomButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    func fullyVisibleCells(_ inTableView: UITableView) ->  StreamMessageTableViewCell? {
        
        let visibleCells = inTableView.visibleCells
        if visibleCells.count > 1 {
            let  visibleIndexPath = visibleCells[1]
            return visibleIndexPath as? StreamMessageTableViewCell
        } else if visibleCells.count > 0 {
            return visibleCells[0] as? StreamMessageTableViewCell
        }
        return nil
        
    }
    
    // MARK: - ACTIONS
    
    @objc func scrollToBottom(){
        
        guard let viewModel else { return }
        let messages = viewModel.messages
        if messages.count > 0 {
            let lastIndex = IndexPath(row: messages.count - 1, section: 0)
            self.scrollToBottomButton.isHidden = true
            self.messageTableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
        }
        
    }
    
    @objc func deleteButtonTapped(_ button: UIButton){
        
        guard let viewModel else { return }
        let messages = viewModel.messages
        
        if messages.count > 0 {
            
            messageTableView.beginUpdates()
        
            if let messageCell = messageTableView.cellForRow(at: IndexPath(row: button.tag, section: 0)) as? StreamMessageTableViewCell {
                messageCell.backgroundMessageView.backgroundColor = appearance.colors.appRed
                messageCell.userProfileImage.backgroundColor = appearance.colors.appColor
                messageCell.activityIndicator.isHidden = false
                messageCell.activityIndicator.startAnimating()
            }
            
            messageTableView.endUpdates()
            
            delegate?.didDeleteButtonTapped(messageInfo: messages[button.tag])
        }
        
    }
    
    @objc func profileButtonTapped(_ sender: UIButton) {
        
        guard let viewModel else { return }
        let messages = viewModel.messages
        if messages.count > 0 {
            delegate?.didProfileTapped(messageInfo: messages[sender.tag])
        }
        
    }

    @objc func acceptButtonTapped(_ sender: UIButton) {
        guard let viewModel else { return }
        let messages = viewModel.messages
        if messages.count > 0 {
            delegate?.didCopublisherRequestResponseTapped(response: .accepted, messageInfo: messages[sender.tag], index: sender.tag)
        }
    }
    
    @objc func rejectButtonTapped(_ sender: UIButton) {
        guard let viewModel else { return }
        let messages = viewModel.messages
        if messages.count > 0 {
            delegate?.didCopublisherRequestResponseTapped(response: .rejected, messageInfo: messages[sender.tag], index: sender.tag)
        }
    }
    
}
