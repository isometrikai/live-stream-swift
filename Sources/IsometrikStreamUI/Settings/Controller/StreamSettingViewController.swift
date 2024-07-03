//
//  StreamSettingViewController.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 08/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

enum StreamSettingType {
    case report
    case speaker
    case audio
    case camera
    case delete
    case edit
    case none
}

struct StreamSettingData {
    let settingLabel: String
    let settingImage: UIImage
    var labelColor: UIColor = .white
    var streamSettingType: StreamSettingType?
}

protocol StreamSettingDelegate {
    func didTapSettingOptionFor(actionType: StreamSettingType)
}

class StreamSettingViewController: UIViewController, AppearanceProvider {

    // MARK: - PROPERTIES

    var streamViewModel: StreamViewModel?
    var delegate: StreamSettingDelegate?
    
    var settingData: [StreamSettingData]? {
        didSet {
            self.settingTableView.reloadData()
        }
    }
    
    lazy var settingTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(StreamSettingOptionTableViewCell.self, forCellReuseIdentifier: "StreamSettingOptionTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.contentInset = .init(top: 15, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.close.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        view.backgroundColor = appearance.colors.appDarkGray
        view.addSubview(settingTableView)
        view.addSubview(closeButton)
    }
    
    func setupConstraints(){
        settingTableView.ism_pin(to: view)
        NSLayoutConstraint.activate([
            settingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            settingTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            settingTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            settingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            closeButton.widthAnchor.constraint(equalToConstant: 35),
            closeButton.heightAnchor.constraint(equalToConstant: 35),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
    }
    
    // MARK: - ACTIONS
    
    @objc func closeButtonTapped(){
        self.dismiss(animated: true)
    }

}

extension StreamSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let settingData else { return Int() }
        return settingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let settingData else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "StreamSettingOptionTableViewCell", for: indexPath) as! StreamSettingOptionTableViewCell
        cell.data = settingData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let settingData else { return }
        delegate?.didTapSettingOptionFor(actionType: settingData[indexPath.row].streamSettingType ?? .none)
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? StreamSettingOptionTableViewCell {
            UIView.animate(withDuration: 0.2) {
                cell.contentView.backgroundColor = .white.withAlphaComponent(0.2)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? StreamSettingOptionTableViewCell {
            UIView.animate(withDuration: 0.2) {
                cell.contentView.backgroundColor = .clear
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
}
