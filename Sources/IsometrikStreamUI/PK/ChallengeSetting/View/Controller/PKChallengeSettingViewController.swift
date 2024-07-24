//
//  PKChallengeSettingViewController.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 29/11/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import UIKit

class PKChallengeSettingViewController: UIViewController, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var viewModel: PkChallengeViewModel
    
    let headerView: PKChallengeHeaderView = {
        let view = PKChallengeHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let challengeDurationView: PKChallengeDurationView = {
        let view = PKChallengeDurationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var startChallengeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Confirm & Start", for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h8)
        button.setTitleColor(appearance.colors.appSecondary, for: .normal)
        button.backgroundColor = appearance.colors.appColor
        button.layer.cornerRadius = 27.5
        button.ismTapFeedBack()
        button.addTarget(self, action: #selector(startChallengeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - MAIN
    
    init(viewModel: PkChallengeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupDefaults()
    }
    
    // MARK: - FUNTIONS
    
    func setupViews(){
        view.backgroundColor = appearance.colors.appDarkGray
        view.addSubview(headerView)
        view.addSubview(challengeDurationView)
        view.addSubview(startChallengeButton)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 200),
            
            challengeDurationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            challengeDurationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            challengeDurationView.heightAnchor.constraint(equalToConstant: 110),
            challengeDurationView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 15),
            
            startChallengeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            startChallengeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startChallengeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startChallengeButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    func setupDefaults(){
        viewModel.setDefaultChallengeDuration()
        challengeDurationView.viewModel = viewModel
        challengeDurationView.durationCollectionView.selectItem(at: viewModel.selectedIndex, animated: true, scrollPosition: .left)
    }
    
    // MARK: - ACTIONS
    
    @objc func startChallengeButtonTapped(){
        let timeMin = "\(viewModel.challengeDuration?[viewModel.selectedIndex.row].duration ?? 0)"
        viewModel.startPK_CallBack?(timeMin)
        self.dismiss(animated: true)
    }

}
