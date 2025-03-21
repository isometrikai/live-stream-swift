//
//  RestreamChannelsViewController.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 11/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream
import SkeletonView

class RestreamChannelsViewController: UIViewController, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var viewModel = RestreamViewModel()
    
    let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.back.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .black
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var headerTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Restream Channels".localized
        label.textColor = .black
        label.font = appearance.font.getFont(forTypo: .h4)
        return label
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return view
    }()
    
    lazy var restreamChannelTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RestreamOptionTableViewCell.self, forCellReuseIdentifier: "RestreamOptionTableViewCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isSkeletonable = true
        return tableView
    }()
    
    // MARK: - MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        loadData()
        
        restreamChannelTableView.rowHeight = 50
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(headerView)
        headerView.addSubview(dividerView)
        headerView.addSubview(backButton)
        headerView.addSubview(headerTitle)
        view.addSubview(restreamChannelTableView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 55),
            
            dividerView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            headerTitle.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            headerTitle.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 35),
            backButton.heightAnchor.constraint(equalToConstant: 35),
            backButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            restreamChannelTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            restreamChannelTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            restreamChannelTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            restreamChannelTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    func loadData(){
       
        self.restreamChannelTableView.showSkeleton(usingColor: .clouds, transition: .crossDissolve(0.5))
        
        viewModel.getRestreamChannels { success, error in
            self.restreamChannelTableView.hideSkeleton(transition: .crossDissolve(0.5))
            if error == nil {
                self.restreamChannelTableView.reloadData()
            } else {
                // error
            }
            
        }
    }
    
    // MARK: - ACTIONS
    
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }

}
