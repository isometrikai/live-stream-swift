//
//  CopublisherStreamSettingViewController.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 28/07/22.
//

import UIKit

//protocol CoPublisherStreamSettingsActionDelegate {
//    func didOptionTapped(for type: StreamSettingTypes, session: VideoSession?, index: Int)
//}

//class CopublisherStreamSettingViewController: UIViewController {

//    // MARK: - PROPERTIES
//    
//    var settingsData: [StreamSettingData]? {
//        didSet {
//            self.settingsOptionTableView.reloadData()
//        }
//    }
//    
//    var delegate: CoPublisherStreamSettingsActionDelegate?
//    var session: VideoSession?
//    var selectedIndex: Int = 0
//    
//    lazy var settingsOptionTableView: UITableView = {
//        let tableView = UITableView()
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.showsVerticalScrollIndicator = false
//        tableView.tableFooterView = UIView()
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(StreamSettingsTableViewCell.self, forCellReuseIdentifier: "StreamSettingsTableViewCell")
//        tableView.backgroundColor = .clear
//        tableView.separatorStyle = .none
//        return tableView
//    }()
//    
//    // MARK: - MAIN
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .black.withAlphaComponent(0.8)
//        setupViews()
//        setupConstraints()
//    }
//    
//    // MARK: - FUNTIONS
//    
//    func setupViews(){
//        view.addSubview(settingsOptionTableView)
//    }
//    
//    func setupConstraints(){
//        settingsOptionTableView.ism_pin(to: view)
//    }

//}

//extension CopublisherStreamSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let settingsData = settingsData else { return Int() }
//        return settingsData.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let settingsData = settingsData else { return UITableViewCell() }
//        let cell = tableView.dequeueReusableCell(withIdentifier: "StreamSettingsTableViewCell", for: indexPath) as! StreamSettingsTableViewCell
//        cell.data = settingsData[indexPath.row]
//        cell.selectionStyle = .none
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let settingData = settingsData?[indexPath.row] else { return }
//        delegate?.didOptionTapped(for: settingData.streamSettingType, session: session, index: selectedIndex)
//        self.dismiss(animated: true)
//    }
//    
//    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) as? StreamSettingsTableViewCell {
//            UIView.animate(withDuration: 0.2) {
//                cell.contentView.backgroundColor = .white.withAlphaComponent(0.2)
//            }
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) as? StreamSettingsTableViewCell {
//            UIView.animate(withDuration: 0.2) {
//                cell.contentView.backgroundColor = .clear
//            }
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 55
//    }
    
    
    
//}
