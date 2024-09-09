//
//  StreamSettingViewController.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 08/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

public enum StreamSettingType {
    case report
    case speaker
    case audio
    case camera
    case delete
    case edit
    case none
    case kickout
}

public struct StreamSettingData {
    let settingLabel: String
    let settingImage: UIImage
    var labelColor: UIColor = .white
    var streamSettingType: StreamSettingType?
    
    public init(settingLabel: String, settingImage: UIImage, labelColor: UIColor, streamSettingType: StreamSettingType? = nil) {
        self.settingLabel = settingLabel
        self.settingImage = settingImage
        self.labelColor = labelColor
        self.streamSettingType = streamSettingType
    }
    
}

public protocol StreamSettingDelegate {
    func didTapSettingOptionFor(actionType: StreamSettingType)
}

public class StreamSettingViewController: UIViewController, ISMAppearanceProvider {

    // MARK: - PROPERTIES

    public var streamViewModel: StreamViewModel?
    public var delegate: StreamSettingDelegate?
    
    public var settingData: [StreamSettingData]? {
        didSet {
            self.settingTableView.reloadData()
        }
    }
    
    lazy public var settingTableView: UITableView = {
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
    
    lazy public var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.close.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - MAIN
    
    public override func viewDidLoad() {
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
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let settingData else { return Int() }
        return settingData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let settingData else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "StreamSettingOptionTableViewCell", for: indexPath) as! StreamSettingOptionTableViewCell
        cell.data = settingData[indexPath.row]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let settingData else { return }
        delegate?.didTapSettingOptionFor(actionType: settingData[indexPath.row].streamSettingType ?? .none)
        self.dismiss(animated: true)
    }
    
    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? StreamSettingOptionTableViewCell {
            UIView.animate(withDuration: 0.2) {
                cell.contentView.backgroundColor = .white.withAlphaComponent(0.2)
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? StreamSettingOptionTableViewCell {
            UIView.animate(withDuration: 0.2) {
                cell.contentView.backgroundColor = .clear
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
}
