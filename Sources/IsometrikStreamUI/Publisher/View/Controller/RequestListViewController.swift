//
//  RequestListViewController.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 16/06/22.
//

import UIKit
import IsometrikStream
import SkeletonView

class RequestListViewController: UIViewController, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var viewModel: PublisherViewModel
    var delegate: StreamRequestListActionDelegate?
    
    lazy var headerView: StreamChildControllerHeaderView = {
        let view = StreamChildControllerHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.headerLabel.text = "Requests"
        view.headerImage.image = appearance.images.requestList.withRenderingMode(.alwaysTemplate)
        view.headerImage.tintColor = .white
        view.countLabel.text = "0"
        return view
    }()
    
    lazy var requestListTableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.tableFooterView = UIView()
        tableview.showsVerticalScrollIndicator = false
        tableview.separatorStyle = .none
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = .clear
        tableview.register(StreamRequestListTableViewCell.self, forCellReuseIdentifier: "StreamRequestListTableViewCell")
        tableview.isSkeletonable = true
        return tableview
    }()
    
    lazy var defaultView: StreamDefaultEmptyView = {
        let view = StreamDefaultEmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.defaultImageView.image = appearance.images.noViewers
        view.defaultLabel.text = "No Requests Found"
        return view
    }()
    
    // MARK: - MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        requestListTableView.rowHeight = 70
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadRequests()
        addObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeAllObserver()
    }
    
    init(viewModel: PublisherViewModel) {
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
        view.addSubview(requestListTableView)
        view.addSubview(defaultView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 55),
            
            requestListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            requestListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            requestListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            requestListTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            defaultView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            defaultView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            defaultView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            defaultView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func addObservers(){
        let isometrik = viewModel.isometrik
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttRequestToBeCoPublisherAdded), name: ISMMQTTNotificationType.mqttRequestToBeCoPublisherAdded.name, object: nil)
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttRequestToBeCoPublisherRemoved), name: ISMMQTTNotificationType.mqttRequestToBeCoPublisherRemoved.name, object: nil)
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttCopublishRequestAccepted), name: ISMMQTTNotificationType.mqttCopublishRequestAccepted.name, object: nil)
        
        isometrik.getMqttSession().addObserverForMQTT(self, selector: #selector(self.mqttCopublishRequestDenied), name: ISMMQTTNotificationType.mqttCopublishRequestDenied.name, object: nil)
        
    }
    
    func removeAllObserver(){
        let isometrik = viewModel.isometrik
        
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttRequestToBeCoPublisherAdded.name, object: nil)
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttRequestToBeCoPublisherRemoved.name, object: nil)
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttCopublishRequestAccepted.name, object: nil)
        isometrik.getMqttSession().removeObserverForMQTT(self, name: ISMMQTTNotificationType.mqttCopublishRequestDenied.name, object: nil)
    }
    
    func loadRequests() {
        
        
        let baseColor = UIColor.colorWithHex(color: "#2C2C2C")
        let secondaryColor = UIColor.colorWithHex(color: "#1E1E1E")
        let accentColor = UIColor.colorWithHex(color: "#3A3A3A")

        let gradient = SkeletonGradient(baseColor: baseColor, secondaryColor: secondaryColor)
        
        // show skeleton view
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .topLeftBottomRight)
        requestListTableView.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation, transition: .crossDissolve(0.25))

        viewModel.getRequestList { result in
            
            self.requestListTableView.hideSkeleton(transition: .crossDissolve(0.25))
            
            switch result {
            case .success:
                DispatchQueue.main.async{
                    self.reloadUI()
                    self.requestListTableView.reloadData()
                }
 
            case let .failure(msg):
                self.reloadUI()
                self.view.showToast(message: msg)
            }
        }
        
    }
    
    func reloadUI(){
        let requestList = self.viewModel.requestList
        if requestList.count == 0 {
            self.headerView.countLabel.text = "0"
            self.defaultView.isHidden = false
        } else {
            self.headerView.countLabel.text = "\(requestList.count)"
            self.defaultView.isHidden = true
        }
    }
    
    // MARK: - ACTIONS
    
    @objc private func mqttRequestToBeCoPublisherAdded(notification: NSNotification) {
        
        guard let requestData = notification.userInfo?["data"] as? ISMRequest else {
            return
        }
        
        print("REQUEST INFO::: -->> \(requestData)")
        viewModel.addRequest(requestData: requestData) { success in
            if success {
                self.reloadUI()
                self.loadRequests()
            }
        }
        
    }
    
    @objc func mqttRequestToBeCoPublisherRemoved(notification: NSNotification){
        
        guard let requestData = notification.userInfo?["data"] as? ISMRequest else {
            return
        }
        
        viewModel.removeRequest(requestData: requestData) { success in
            if success {
                self.reloadUI()
                self.requestListTableView.reloadData()
            }
        }
        
    }
    
    @objc public func mqttCopublishRequestAccepted(notification: NSNotification) {
        guard let requestData = notification.userInfo?["data"] as? ISMRequest else {
            return
        }
        
        viewModel.updateRequestStatus(requestData: requestData) { success in
            if success {
                self.loadRequests()
            }
        }
        
    }
    
    @objc public func mqttCopublishRequestDenied(notification: Notification){
        guard let requestData = notification.userInfo?["data"] as? ISMRequest else {
            return
        }
        
        viewModel.updateRequestStatus(requestData: requestData) { success in
            if success {
                self.requestListTableView.reloadData()
            }
        }
    }

}

extension RequestListViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.requestList.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "StreamRequestListTableViewCell"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StreamRequestListTableViewCell", for: indexPath) as! StreamRequestListTableViewCell
        cell.selectionStyle = .none
        let userData = viewModel.requestList[indexPath.row]
        cell.data = userData
        cell.delegate = self
        cell.tag = indexPath.row
        cell.contentView.isUserInteractionEnabled = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

extension RequestListViewController: StreamRequestListActionDelegate {
    
    func didAcceptActionTapped(_ index: Int) {
        
        let isometrik = viewModel.isometrik
        let streamInfo = viewModel.streamData
        
        let requestByUserId = viewModel.requestList[index].userId ?? ""
        let streamId = streamInfo.streamId ?? ""
        
        isometrik.getIsometrik().acceptCopublishRequest(streamId: streamId, requestByUserId: requestByUserId) { (result) in
            self.loadRequests()
        }failure: { error in
            switch error{
            case .noResultsFound(_):
                // handle noresults found here
                break
            case .invalidResponse:
                DispatchQueue.main.async {
                    self.view.showToast( message: "Accept CoPublish Error : Invalid Response")
                }
            case.networkError(let error):
                self.view.showToast( message: "Network Error \(error.localizedDescription)")
                
            case .httpError(let errorCode, let errorMessage):
                DispatchQueue.main.async{
                    self.view.showToast( message: "\(errorCode) \(errorMessage?.error ?? "")")
                }
            default :
                break
            }
        }
        
    }
    
    func didDeclineActionTapped(_ index: Int) {
        
        let isometrik = viewModel.isometrik
        let streamInfo = viewModel.streamData
        
        let requestByUserId = viewModel.requestList[index].userId ?? ""
        let streamId = streamInfo.streamId ?? ""
        
        print("requestByUserId :: \(requestByUserId)")
        print("STREAM ID :: \(streamId)")
        
        isometrik.getIsometrik().denyCopublishRequest(streamId: streamId, requestByUserId: requestByUserId) { result in
            self.loadRequests()
        }failure: { error in
            switch error{
            case .noResultsFound(_):
                // handle noresults found here
                break
            case .invalidResponse:
                DispatchQueue.main.async {
                    self.view.showToast( message: "CoPublish Error : Invalid Response")
                }
            case.networkError(let error):
                self.view.showToast( message: "Network Error \(error.localizedDescription)")
              
            case .httpError(let errorCode, let errorMessage):
                DispatchQueue.main.async{
                    self.view.showToast( message: "Deny Copublisher \(errorCode) \(errorMessage?.error ?? "")")
                }
            default :
                break
            }
        }
        
    }
    
}
