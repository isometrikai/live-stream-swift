//
//  StreamReportViewController.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 03/01/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

final public class StreamReportViewController: UIViewController, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    let userViewModel = ISMUserViewModel()
    
    public lazy var headerView: CustomHeaderView = {
        let view = CustomHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.headerTitle.text = "Report".localized
        view.headerTitle.font = appearance.font.getFont(forTypo: .h3)
        view.headerTitle.textAlignment = .center
        view.dividerView.isHidden = false
        return view
    }()
    
    public lazy var reasonsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(StreamReportTableViewCell.self, forCellReuseIdentifier: "StreamReportTableViewCell")
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tableView.delaysContentTouches = false
        return tableView
    }()
    
    // MARK: MAIN -
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        
        // loading reasons
        DispatchQueue.main.async {
            CustomLoader.shared.startLoading()
        }
//        userViewModel.getReportReasons { success, error in
//            CustomLoader.shared.stopLoading()
//            if success {
//                self.reasonsTableView.reloadData()
//            }
//        }
        
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(reasonsTableView)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            reasonsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reasonsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            reasonsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            reasonsTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
    }


}

extension StreamReportViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return userViewModel.reportReasons.count
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StreamReportTableViewCell", for: indexPath) as! StreamReportTableViewCell
//        cell.reasonLabel.text = userViewModel.reportReasons[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard userViewModel.reportReasons.count > 0 else { return }
//        let reason = userViewModel.reportReasons[indexPath.row]
//        userViewModel.reportAUser(reason: reason) { success, error in
//            if success {
//                self.view.showToast(message: "Successfully Reported!")
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    self.dismiss(animated: true)
//                }
//            } else {
//                self.ism_showAlert("Error", message: "\(error ?? "")")
//            }
//        }
    }
    
    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? StreamReportTableViewCell {
            UIView.animate(withDuration: 0.2, delay: 0) {
                cell.cardView.transform = .init(scaleX: 0.95, y: 0.95)
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? StreamReportTableViewCell {
            UIView.animate(withDuration: 0.2, delay: 0) {
                cell.cardView.transform = .identity
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
