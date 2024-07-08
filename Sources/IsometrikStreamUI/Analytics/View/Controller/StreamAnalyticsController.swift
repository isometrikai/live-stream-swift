//
//  StreamAnalyticsViewController.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 04/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

class StreamAnalyticsController: UIViewController, AppearanceProvider {
    
    // MARK: - PROPERTIES
    
    var viewModel: StreamAnalyticViewModel? {
        didSet {
            loadData()
        }
    }
    
    var durationValue: Int?
    
    var dismissCallBack: (()->Void)?
    
    let logoCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 50
        view.layer.borderWidth = 1
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        return view
    }()
    
    let logoImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "")
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    let defaultImageView: CustomDefaultProfileView = {
        let view = CustomDefaultProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.borderWidth = 0
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.close.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.ismTapFeedBack()
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Live".localized
        label.font = appearance.font.getFont(forTypo: .h3)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    // - Info view
    
    let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return view
    }()
    
    let topHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var totalHearts: AnalyticsInfoView = {
        let view = AnalyticsInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.featureImage.image = appearance.images.reaction.withRenderingMode(.alwaysTemplate)
        view.featureImage.tintColor = .black
        view.featureLabel.text = "Reactions"
        view.valueLabel.text = "--"
        return view
    }()
    
    lazy var totalOrders: AnalyticsInfoView = {
        let view = AnalyticsInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.featureImage.image = appearance.images.vendor
        view.featureLabel.text = "Orders".localized
        view.valueLabel.text = "--"
        return view
    }()
    
    lazy var totalViewers: AnalyticsInfoView = {
        let view = AnalyticsInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.featureImage.image = appearance.images.viewerStat
        view.featureLabel.text = "Viewers".localized
        view.valueLabel.text = "--"
        return view
    }()
    
    lazy var totalFollowers: AnalyticsInfoView = {
        let view = AnalyticsInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.featureImage.image = appearance.images.followersStat
        view.featureLabel.text = "Followers".localized
        view.valueLabel.text = "--"
        view.isHidden = true
        return view
    }()
    
    let bottomHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var sellingQuantity: AnalyticsInfoView = {
        let view = AnalyticsInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.featureImage.image = appearance.images.sellingQtyStat
        view.featureLabel.text = "Selling Quantity".localized
        view.valueLabel.text = "--"
        return view
    }()
    
    lazy var earning: AnalyticsInfoView = {
        let view = AnalyticsInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.featureImage.image = appearance.images.earningStat
        view.featureLabel.text = "Sales Value".localized
        view.valueLabel.text = "--"
        return view
    }()
    
    lazy var duration: AnalyticsInfoView = {
        let view = AnalyticsInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.featureImage.image = appearance.images.durationStat
        view.featureLabel.text = "Duration".localized
        view.valueLabel.text = "--:--"
        return view
    }()
    
    //:
    
    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return view
    }()
    
    // - Viewer container
    
    lazy var viewerContainer: ViewerContainer = {
        let view = ViewerContainer()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    //:
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = appearance.colors.appColor
        button.setTitle("Done".localized, for: .normal)
        button.setTitleColor(appearance.colors.appSecondary, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h4)
        button.layer.cornerRadius = 25
        button.ismTapFeedBack()
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
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
        view.backgroundColor = .white
        view.addSubview(logoCoverView)
        logoCoverView.addSubview(defaultImageView)
        logoCoverView.addSubview(logoImage)
        
        view.addSubview(closeButton)
        
        view.addSubview(titleLabel)
        
        view.addSubview(dividerView)
        view.addSubview(topHorizontalStackView)
        view.addSubview(bottomHorizontalStackView)
        
        topHorizontalStackView.addArrangedSubview(totalHearts)
        topHorizontalStackView.addArrangedSubview(totalOrders)
        topHorizontalStackView.addArrangedSubview(totalViewers)
        
        //bottomHorizontalStackView.addArrangedSubview(sellingQuantity)
        //bottomHorizontalStackView.addArrangedSubview(totalFollowers)
        bottomHorizontalStackView.addArrangedSubview(earning)
        bottomHorizontalStackView.addArrangedSubview(duration)
        
        view.addSubview(separatorView)
        view.addSubview(viewerContainer)
        
        view.addSubview(actionButton)
    }
    
    func setupConstraints(){
        logoImage.ism_pin(to: logoCoverView)
        defaultImageView.ism_pin(to: logoCoverView)
        NSLayoutConstraint.activate([
            logoCoverView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoCoverView.widthAnchor.constraint(equalToConstant: 100),
            logoCoverView.heightAnchor.constraint(equalToConstant: 100),
            logoCoverView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: logoCoverView.bottomAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            
            dividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            dividerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            
            topHorizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            topHorizontalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            topHorizontalStackView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 20),
            topHorizontalStackView.heightAnchor.constraint(equalToConstant: 80),
            
            bottomHorizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            bottomHorizontalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            bottomHorizontalStackView.topAnchor.constraint(equalTo: topHorizontalStackView.bottomAnchor, constant: 25),
            bottomHorizontalStackView.heightAnchor.constraint(equalToConstant: 80),
            
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 7),
            separatorView.topAnchor.constraint(equalTo: bottomHorizontalStackView.bottomAnchor, constant: 30),
            
            viewerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewerContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewerContainer.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func loadData(){
        guard let viewModel,
              let isometrik = viewModel.isometrik
        else { return }
        
        let firstName = isometrik.getUserSession().getFirstName()
        let lastName = isometrik.getUserSession().getLastName()
        let userImage = isometrik.getUserSession().getUserImage()
        
        if userImage != UserDefaultsProvider.shared.getIsometrikDefaultProfile() {
            if let imageUrl = URL(string: userImage) {
                logoImage.kf.setImage(with: imageUrl)
            }
        } else {
            logoImage.image = UIImage()
        }
        
        let initialText = "\(firstName.prefix(1))\(lastName.prefix(1))"
        defaultImageView.initialsText.text = initialText
        defaultImageView.initialsText.font = appearance.font.getFont(forTypo: .h3)
        
        // get stream Analytics
        //Helper.showPI()
        viewModel.fetchStreamAnalytics { success, error in
            //Helper.hidePI()
            if success {
                guard let analyticData = viewModel.analyticData else { return }
                self.totalHearts.valueLabel.text = "\(analyticData.hearts ?? 0)"
                self.totalViewers.valueLabel.text = "\(analyticData.totalViewersCount ?? 0)"
                self.totalOrders.valueLabel.text = "\(analyticData.totalSold ?? 0)"
                self.totalFollowers.valueLabel.text = "\(analyticData.followers ?? 0)"
                //self.sellingQuantity.valueLabel.text = "\(analyticData.soldCount ?? 0)"
                self.earning.valueLabel.text = "\(analyticData.totalSales ?? 0)"
                
                if let durationVal = self.durationValue {
                    self.duration.valueLabel.text = Double(durationVal).asString(style: .positional)
                } else {
                    self.duration.valueLabel.text = Double(analyticData.duration ?? 0).asString(style: .positional)
                }
                
            }
        }
        viewModel.fetchStreamAnalyticsViewers { success, error in
            if success {
                self.viewerContainer.viewers = viewModel.streamViewers
            } else {
                print(error)
            }
        }
        
    }
    
    // MARK: - ACTIONS
    
    @objc func actionButtonTapped(){
        self.dismissCallBack?()
        self.dismiss(animated: true)
    }

}

extension StreamAnalyticsController: StreamAnalyticViewersActionDelegate {
    
    func didTapFollowButtonTapped(index: Int) {
        
        guard let viewModel else { return }
        
        viewModel.followUser(index: index) {
            self.viewerContainer.viewers = viewModel.streamViewers
        }
        
    }
    
}

class AnalyticsInfoView: UIView, AppearanceProvider {
    
    // MARK: - PROPERTIES
    
    let featureImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var featureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "feature label"
        label.textColor = UIColor.colorWithHex(color: "#9797BE")
        label.font = appearance.font.getFont(forTypo: .h6)
        label.textAlignment = .center
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "123 min"
        label.textColor = .black
        label.font = appearance.font.getFont(forTypo: .h3)
        label.textAlignment = .center
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.alignment = .center
        return stackView
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
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        addSubview(stackView)
        stackView.addArrangedSubview(featureImage)
        stackView.addArrangedSubview(featureLabel)
        stackView.addArrangedSubview(valueLabel)
    }
    
    func setupConstraints(){
        stackView.ism_pin(to: self)
        NSLayoutConstraint.activate([
            featureImage.widthAnchor.constraint(equalToConstant: 25),
            featureImage.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
}
