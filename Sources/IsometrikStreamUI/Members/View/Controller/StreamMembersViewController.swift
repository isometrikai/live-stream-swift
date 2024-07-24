//
//  StreamMembersViewController.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 21/04/22.
//

import UIKit
import IsometrikStream

class StreamMembersViewController: UIViewController, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var viewModel: StreamMemberViewModel
    
    var updateMemebrsCallBack : (([ISMMember])->())?
    var delegate: StreamMemberListActionDelegate?
    
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
        return tableView
    }()
    
    lazy var defaultView: StreamDefaultEmptyView = {
        let view = StreamDefaultEmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.defaultImageView.image = appearance.images.noViewers
        view.defaultLabel.text = "No Member Found"
        return view
    }()
    
    
    // MARK: - MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
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
        view.backgroundColor = .black.withAlphaComponent(0.8)
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(defaultView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            defaultView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            defaultView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            defaultView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 15),
            defaultView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func loadStreamMembers(){
        viewModel.getStreamMembers { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    let members = self.viewModel.memberList
                    self.updateMemebrsCallBack?(members)
                    if members.count > 0 {
                        self.defaultView.isHidden = true
                    } else {
                        self.defaultView.isHidden = false
                    }
                    self.headerView.memberCountLabel.text = "\(members.count)"
                    self.tableView.reloadData()
                }
               
                
            case let .failure(msg):
                self.view.showToast(message: msg)
            }
        }
    }
    
}

extension StreamMembersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.memberList.count
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
        label.text = "Members".ism_localized
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
    
    lazy var memberCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h8)
        return label
    }()
    
    let viewerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "ism_Icon awesome-user")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        stackView.addArrangedSubview(viewerImage)
        stackView.addArrangedSubview(memberCountLabel)
        addSubview(dividerView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            viewerImage.widthAnchor.constraint(equalToConstant: 15),
            viewerImage.heightAnchor.constraint(equalToConstant: 15),
            
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
}

extension StreamMembersViewController: StreamMemberListActionDelegate {
   
    
    func didkickoutMemberTapped(member: ISMMember) {
        self.dismiss(animated: true)
        delegate?.didkickoutMemberTapped(member: member)
    }
    
    func didMemberTapped(withId memberId: String) {
        self.dismiss(animated: true)
        delegate?.didMemberTapped(withId: memberId)
    }
    
}
