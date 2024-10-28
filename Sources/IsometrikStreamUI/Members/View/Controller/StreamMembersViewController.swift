//
//  StreamMembersViewController.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 21/04/22.
//

import UIKit
import IsometrikStream
import SkeletonView

class StreamMembersViewController: UIViewController, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var viewModel: StreamMemberViewModel
    
    let headerView: StreamMemberHeaderView = {
        let view = StreamMemberHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StreamMemberTableViewCell.self, forCellReuseIdentifier: "StreamMemberTableViewCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isSkeletonable = true
        return tableView
    }()
    
    lazy var defaultView: StreamDefaultEmptyView = {
        let view = StreamDefaultEmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.defaultImageView.image = appearance.images.noViewers
        view.defaultLabel.text = "No Member Found"
        view.defaultLabel.textColor = .white
        view.isHidden = true
        return view
    }()
    
    
    // MARK: - MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        tableView.rowHeight = 70
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadStreamMembers()
    }
    
    init(viewModel: StreamMemberViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNTIONS
    
    func setupViews(){
        view.backgroundColor = appearance.colors.appDarkGray
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(defaultView)
    }
    
    func setupConstraints(){
        defaultView.ism_pin(to: view)
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 55),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
    }
    
    func loadStreamMembers(){
        self.tableView.showAnimatedSkeleton(usingColor: .wetAsphalt, transition: .crossDissolve(0.25))
        
        viewModel.getStreamMembers { result in
            
            self.tableView.hideSkeleton(transition: .crossDissolve(0.25))
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    let members = self.viewModel.memberList
                    self.viewModel.updateMemebrsCallBack?(members)
                    if members.count > 0 {
                        self.defaultView.isHidden = true
                    } else {
                        self.defaultView.isHidden = false
                    }
                    self.headerView.memberCountView.featureLabel.text = "\(members.count)"
                    self.tableView.reloadData()
                }
               
                
            case let .failure(msg):
                self.defaultView.isHidden = false
                self.view.showToast(message: msg)
            }
        }
    }
    
}

extension StreamMembersViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.memberList.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "StreamMemberTableViewCell"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StreamMemberTableViewCell", for: indexPath) as! StreamMemberTableViewCell
        cell.selectionStyle = .none
        cell.isometrik = viewModel.isometrik
        cell.configureCell(member: viewModel.memberList[indexPath.row])
        cell.delegate = self
        cell.contentView.isUserInteractionEnabled = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

class StreamMemberHeaderView: UIView, ISMAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Members"
        label.font = appearance.font.getFont(forTypo: .h4)
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 3
        return stackView
    }()
    
    lazy var memberCountView: CustomFeatureView = {
        let featureView = CustomFeatureView()
        featureView.translatesAutoresizingMaskIntoConstraints = false
        featureView.iconImageView.image = appearance.images.user.withRenderingMode(.alwaysTemplate)
        featureView.iconImageView.tintColor = .white
        featureView.featureLabel.textColor = .white
        return featureView
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return view
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
        addSubview(headerLabel)
        addSubview(stackView)
        stackView.addArrangedSubview(memberCountView)
        addSubview(dividerView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            memberCountView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
}

extension StreamMembersViewController: StreamMemberListActionDelegate {
   
    
    func didkickoutMemberTapped(member: ISMMember) {
        self.dismiss(animated: true)
        viewModel.delegate?.didkickoutMemberTapped(member: member)
    }
    
    func didMemberTapped(withId memberId: String) {
        self.dismiss(animated: true)
        viewModel.delegate?.didMemberTapped(withId: memberId)
    }
    
}
