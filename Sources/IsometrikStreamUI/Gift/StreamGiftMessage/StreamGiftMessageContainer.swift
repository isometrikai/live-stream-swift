//
//  StreamGiftMessageContainer.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 26/06/24.
//

import UIKit
import IsometrikStream

class StreamGiftMessageContainerView: UIView {

    // MARK: - PROPERTIES
    
    var streamInfo: ISMStream?
    var giftMessages: [ISMComment] = []
    var viewType: UserType = .host
    var currentUser: ISMStreamUser?
    
    lazy var giftTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.register(StreamGiftsTableViewCell.self, forCellReuseIdentifier: "StreamGiftsTableViewCell")
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tableView.isScrollEnabled = false
        return tableView
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
    
    // MARK: - FUNTIONS
    
    func setupViews(){
        addSubview(giftTableView)
    }
    
    func setupConstraints(){
        giftTableView.pin(to: self)
    }
    
    func updateMaskedGradient(){
        let gradient = CAGradientLayer()

        gradient.frame = self.giftTableView.superview?.bounds ?? CGRect.null
        gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 0.15, 0.25]
        self.giftTableView.superview?.layer.mask = gradient
        self.giftTableView.backgroundColor = UIColor.clear
    }
    
}

extension StreamGiftMessageContainerView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return giftMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StreamGiftsTableViewCell", for: indexPath) as! StreamGiftsTableViewCell
        cell.selectionStyle = .none
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        //cell.initiatoDetails = self.streamInfo
        
        if giftMessages.count > indexPath.row {
            let message = giftMessages[indexPath.row]
            
            cell.configureData(messageInfo: message, viewType: viewType, user: currentUser ?? ISMStreamUser.init(userId: "", identifier: "", name: "", imagePath: ""))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
   
}
