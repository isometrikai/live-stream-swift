//
//  StreamViewerChildViewController.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 22/04/22.
//

import UIKit
import IsometrikStream


class StreamViewerChildViewController: UIViewController, ISMAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    var userType: StreamUserType = .viewer
    var skip = 0
    var totalViewerCount = 0
    
    var streamData: ISMStream? {
        didSet {
            guard let streamData = streamData else {
                return
            }
            self.viewers.removeAll()
            self.skip = 0
            self.totalViewerCount = 0
            self.fetchStreamViewers(streamInfo: streamData) {}
        }
    }
    
    var delegate: StreamViewerActionDelegate?
    
    var isometrik: IsometrikSDK? {
        didSet {
            addObservers()
        }
    }
    
    var updateViewerCount_callback: ((Int)->Void)?
    
    var viewers: [ISMViewer] = [] {
        didSet {
            DispatchQueue.main.async { [self] in
                if viewers.count == 0 {
                    self.tableView.isHidden = true
                    headerView.countLabel.text = "\(0)"
                } else {
                    self.tableView.isHidden = false
                    headerView.countLabel.text = "\(totalViewerCount)"
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    let headerView: StreamChildControllerHeaderView = {
        let view = StreamChildControllerHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.headerLabel.text = "Viewers"
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StreamViewerTableViewCell.self, forCellReuseIdentifier: "StreamViewerTableViewCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    lazy var defaultView: StreamDefaultEmptyView = {
        let view = StreamDefaultEmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.defaultImageView.image = appearance.images.noViewers
        view.defaultLabel.text = "No Viewers Found".localized
        return view
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .medium
        indicator.tintColor = .white
        return indicator
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                                    #selector(self.refreshAction),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = appearance.colors.appColor
        return refreshControl
    }()
    
    // MARK: - MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Removing observer when view will disappears
        removeObservers()
    }
    
    // MARK: - FUNTIONS
    
    func setupViews(){
        view.backgroundColor = appearance.colors.appDarkGray
        view.addSubview(headerView)
        view.addSubview(defaultView)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
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
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func addObservers(){
        guard let isometrik = isometrik else { return }
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttViewerRemovedByInitiator), name: ISMMQTTNotificationType.mqttViewerRemovedByInitiator.name, object: nil)
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttStreamStopped), name: ISMMQTTNotificationType.mqttStreamStopped.name, object: nil)
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttViewerJoined), name: ISMMQTTNotificationType.mqttViewerJoined.name, object: nil)
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttViewerRemoved), name: ISMMQTTNotificationType.mqttViewerRemoved.name, object: nil)
        
    }
    
    func removeObservers(){
        
        guard let isometrik = isometrik else { return }
        
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttViewerRemovedByInitiator.name, object: nil)
        
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttStreamStopped.name, object: nil)
        
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttViewerJoined.name, object: nil)
        
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttViewerRemoved.name, object: nil)
        
    }
    
    func viewerExists(withId id: String) -> Bool {
        
        let viewers = self.viewers.filter { viewers in
            viewers.viewerId == id
        }
        
        return viewers.count > 0
    }
    
    // MARK: - ACTIONS
    
    @objc private func mqttViewerRemovedByInitiator(notification: NSNotification) {
        
//        guard let viewerData = notification.userInfo?["data"] as? ViewerRemoveEvent,
//              viewerData.streamId.unwrap == streamData?.streamId.unwrap,
//              viewerExists(withId: viewerData.viewerId.unwrap)
//        else { return }
//        
//        self.viewers.removeAll { viewers in
//            viewers.viewerId == viewerData.viewerId
//        }
        
    }
    
    @objc private func mqttStreamStopped(notification: NSNotification) {
        self.dismiss(animated: true)
    }
    
    @objc private func mqttViewerJoined(notification: NSNotification) {
        
//        guard let viewerData = notification.userInfo?["data"] as? ViewerJoinEvent,
//              viewerData.streamId.unwrap == streamData?.streamId.unwrap,
//              !viewerExists(withId: viewerData.viewerId.unwrap)
//        else { return }
//        
//        let viewer = ISMViewer(viewerId: viewerData.viewerId.unwrap, identifier: viewerData.viewerIdentifier.unwrap, name: viewerData.viewerName.unwrap, imagePath: viewerData.viewerProfilePic.unwrap, joinTime: viewerData.timestamp.unwrap)
//        
//        self.viewers.append(viewer)

    }
    
    @objc private func mqttViewerRemoved(notification: NSNotification) {
//        guard let viewerData = notification.userInfo?["data"] as? ViewerRemoveEvent,
//              viewerData.streamId.unwrap == streamData?.streamId.unwrap,
//              viewerExists(withId: viewerData.viewerId.unwrap)
//        else { return }
//
//        self.viewers.removeAll { viewers in
//            viewers.viewerId == viewerData.viewerId
//        }
    }
    
    @objc func refreshAction(){
        self.skip = 0
        self.viewers.removeAll()
        self.totalViewerCount = 0
        fetchStreamViewers(streamInfo: streamData) {}
    }
    
}

extension StreamViewerChildViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StreamViewerTableViewCell", for: indexPath) as! StreamViewerTableViewCell
        let data = viewers[safe: indexPath.row]
        cell.actionType = .kickout
        cell.isometrik = isometrik
        cell.data = data
        cell.selectionStyle = .none
        cell.tag = indexPath.row
        cell.delegate = self
        cell.contentView.isUserInteractionEnabled = false
        
        // if last item fetch more
        if self.viewers.count > 10 {
            if indexPath.row == self.viewers.count - 1 {
                if totalViewerCount > self.viewers.count {
                    // call for more
                    if let streamData = streamData {
                        fetchStreamViewers(streamInfo: streamData) {}
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? StreamViewerTableViewCell {
            UIView.animate(withDuration: 0.3, delay: 0) {
                cell.backgroundColor = .white.withAlphaComponent(0.1)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? StreamViewerTableViewCell {
            UIView.animate(withDuration: 0.3, delay: 0) {
                cell.backgroundColor = .clear
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewer = viewers[indexPath.row]
        dismiss(animated: true)
        delegate?.didViewerTapped(with: viewer, navigationController: self.navigationController)
    }
    
    // MARK: - FUNTIONS
    
    func fetchStreamViewers(streamInfo: ISMStream?, _ completionHandler: @escaping() -> Void) {
        guard let streamId = streamInfo?.streamId else { return }

        /// Start loading
        isometrik?.getIsometrik().fetchViewers(streamId: streamId, skip: self.skip, limit: 10, completionHandler: { viewerData in
            
            guard let viewers = viewerData.viewers else { return }
            
            self.viewers.removeAll()
            self.viewers.append(contentsOf: viewers)
            if self.viewers.count.isMultiple(of: 10) {
                self.skip += 10
            }
            
            self.totalViewerCount = viewerData.totalCount ?? 0
            self.updateViewerCount_callback?(self.totalViewerCount)
            
            if self.viewers.count == 0 {
                self.defaultView.isHidden = false
            } else {
                self.defaultView.isHidden = true
            }
            
            completionHandler()
            
        }, failure: { error in
            
            print(error)
            self.viewers = []
            self.defaultView.isHidden = false
            self.updateViewerCount_callback?(0)
            completionHandler()
            
        })
    }
    
    func removeViewerByInitiator(initiatorId: String, initiatorName: String, streamId: String, viewerId: String) {
        
        isometrik?.getIsometrik().removeViewer(streamId: streamId, viewerId: viewerId, initiatorId: initiatorId, completionHandler: { _ in
        }, failure: { error in
            print(error)
        })
        
    }
    
}

extension StreamViewerChildViewController: StreamViewerActionDelegate {
    
    func didViewerTapped(with user: ISMViewer?, navigationController: UINavigationController?) {}
    
    func didActionButtonTapped(with index: Int, with data: ISMViewer, actionType: ActionType) {
        
        let userAccess = isometrik?.getUserSession().getUserAccess()
        if userAccess != .moderator {
            return
        }
        
        guard let streamId = streamData?.streamId,
              let viewerId = viewers[index].viewerId  else { return }
        
        let firstName = isometrik?.getUserSession().getFirstName()
        let lastName = isometrik?.getUserSession().getLastName()
        let fullName = "\(firstName ?? "") \(lastName ?? "")"
        
        self.removeViewerByInitiator(initiatorId: isometrik?.getUserSession().getUserId() ?? "", initiatorName: fullName,streamId: streamId, viewerId: viewerId)
        
        self.tableView.beginUpdates()
        
        // removing the data from viewers array
        viewers.remove(at: index)
        
        // show default view if no viewers
        if viewers.count == 0 {
            self.defaultView.isHidden = false
        }
        
        let indexPath = IndexPath(row: index, section: 0)
        self.tableView.deleteRows(at: [indexPath], with: .fade)
        
        self.tableView.endUpdates()
    }
    
}

class StreamChildControllerHeaderView: UIView, ISMAppearanceProvider{
    
    // MARK: - PROPERTIES
    var infoCountStackViewTrailing: NSLayoutConstraint?
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h4)
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h6)
        return label
    }()
    
    lazy var headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = appearance.images.eye.withRenderingMode(.alwaysTemplate)
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
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("", for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h8)
        button.layer.cornerRadius = 17.5
        button.isHidden = true
        button.backgroundColor = appearance.colors.appColor
        button.ismTapFeedBack()
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
    
    // MARK: - FUNTIONS
    
    func setupViews(){
        addSubview(headerLabel)
        addSubview(stackView)
        stackView.addArrangedSubview(headerImage)
        stackView.addArrangedSubview(countLabel)
        addSubview(actionButton)
        addSubview(dividerView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            headerImage.widthAnchor.constraint(equalToConstant: 20),
            headerImage.heightAnchor.constraint(equalToConstant: 20),
            
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            actionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 35),
            actionButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 70)
        ])
        
        infoCountStackViewTrailing = stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15) // otherwise -95
        infoCountStackViewTrailing?.isActive = true
    }
    
}
