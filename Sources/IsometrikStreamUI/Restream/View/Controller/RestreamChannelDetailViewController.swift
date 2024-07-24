//
//  RestreamChannelDetailViewController.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 12/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

class RestreamChannelDetailViewController: UIViewController, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var restreamViewModel: RestreamViewModel?
    var restreamChannelData: ISMRestreamChannel? {
        didSet {
            manageData()
        }
    }
    var toggleOption: Bool = false
    var secureEntry: Bool = true
    
    // Header view
        
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
        label.text = "Channel Name"
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
    
    //:
    
    
    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var enableToggleView: GoLiveCustomToggleView = {
        let toggleView = GoLiveCustomToggleView()
        toggleView.translatesAutoresizingMaskIntoConstraints = false
        toggleView.toggleTitleLabel.text = "Enable stream".localized
        toggleView.activeColor = .black
        toggleView.isSelected = false
        toggleView.actionButton.addTarget(self, action: #selector(enableToggleButtonTapped), for: .touchUpInside)
        return toggleView
    }()
    
    lazy var channelTextView: FormTextView = {
        let view = FormTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.customTextLabel.text = "www.example.com/"
        view.customTextLabel.textColor = .black

        view.formTextImageView.isHidden = false
        view.formTextImageView.image = appearance.images.youtubeLogo
        view.textLabelLeadingAnchor?.constant = 55

        return view
    }()

    lazy var rtmpURLView: FormTextWithTitleView = {
        let view = FormTextWithTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.formTitleLabel.text = "RTMP URL".localized
        view.formTitleLabel.textColor = .black
        
        view.formTextView.customTextLabel.isHidden = true
        view.formTextView.inputTextField.isHidden = false
        view.formTextView.inputTextField.tintColor = .black
        view.formTextView.inputTextField.textColor = .black
        view.formTextView.inputTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter RTMP url".localized,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.colorWithHex(color: "#BCBCE5"),
                NSAttributedString.Key.font: appearance.font.getFont(forTypo: .h8)!
            ]
        )
        
        return view
    }()

    lazy var streamKeyView: FormTextWithTitleView = {
        
        let view = FormTextWithTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.formTitleLabel.text = "Stream Key".localized
        view.formTitleLabel.textColor = .black
        
        view.formTextView.copyButton.isHidden = false
        view.formTextView.copyButton.setImage(appearance.images.eye.withRenderingMode(.alwaysTemplate), for: .normal)
        view.formTextView.copyButton.imageView?.tintColor = .darkGray
        
        view.formTextView.customTextLabel.isHidden = true
        view.formTextView.inputTextField.isHidden = false
        view.formTextView.inputTextField.isSecureTextEntry = true
        view.formTextView.inputTextField.tintColor = .black
        view.formTextView.inputTextField.textColor = .black
        view.formTextView.inputTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter Stream key".localized,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.colorWithHex(color: "#BCBCE5"),
                NSAttributedString.Key.font: appearance.font.getFont(forTypo: .h8)!
            ]
        )
        
        view.formTextView.copyButton.addTarget(self, action: #selector(showStreamKeyTapped), for: .touchUpInside)
        
        return view
    }()

    lazy var infoLabelView: FormSimpleTextView = {
        let view = FormSimpleTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.formLabel.text = ""
        view.formLabel.textColor = .darkGray
        view.actionButton.addTarget(self, action: #selector(infoLabelTapped), for: .touchUpInside)
        return view
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h8)
        button.layer.cornerRadius = 25
        button.backgroundColor = .black
        button.ismTapFeedBack()
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        ism_hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        
        view.backgroundColor = .white
        
        view.addSubview(headerView)
        headerView.addSubview(dividerView)
        headerView.addSubview(backButton)
        headerView.addSubview(headerTitle)
        
        view.addSubview(channelTextView)
        view.addSubview(enableToggleView)
        
        view.addSubview(contentStackView)
        contentStackView.addArrangedSubview(rtmpURLView)
        contentStackView.addArrangedSubview(streamKeyView)
        contentStackView.addArrangedSubview(infoLabelView)
        
        view.addSubview(saveButton)
        
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
            
            channelTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            channelTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            channelTextView.heightAnchor.constraint(equalToConstant: 45),
            channelTextView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            
            enableToggleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            enableToggleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            enableToggleView.heightAnchor.constraint(equalToConstant: 50),
            enableToggleView.topAnchor.constraint(equalTo: channelTextView.bottomAnchor, constant: 10),
            
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentStackView.topAnchor.constraint(equalTo: enableToggleView.bottomAnchor, constant: 10),
        
            channelTextView.heightAnchor.constraint(equalToConstant: 45),
            rtmpURLView.heightAnchor.constraint(equalToConstant: 80),
            streamKeyView.heightAnchor.constraint(equalToConstant: 80),
            
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
            
        ])
    }
    
    func manageData(){
        
        guard let restreamViewModel,
              let restreamChannelData
        else { return }
        
        let channelType = restreamChannelData.channelType.unwrap
        
        let restreamChannelType = RestreamChannelType(rawValue: channelType) ?? .custom
        let channelTypeData = restreamViewModel.getChannelTypeData(forRestreamType: restreamChannelType)
        let channelName = restreamChannelData.channelName ?? ""
        let enabled = restreamChannelData.enabled ?? false
        let ingestURL = restreamChannelData.ingestUrl ?? ""

        if ingestURL != "" {
            
            guard let url = URL(string: ingestURL) else { return }
            
            let streamKey = url.lastPathComponent
            
            let scheme = url.scheme ?? ""
            let host = url.host ?? ""
            
            var path = ""
            
            if #available(iOS 16.0, *) {
                path = url.path()
            } else {
                // Fallback on earlier versions
            }
            
            var componentArr = path.split(separator: "/")
            componentArr.removeLast()
            path = "/\(componentArr.joined(separator: "/"))"
            
            var rtmpURL = scheme + "://" + host + path
            
            rtmpURLView.formTextView.inputTextField.text = "\(rtmpURL)"
            streamKeyView.formTextView.inputTextField.text = "\(streamKey)"
        }
        
        toggleOption = enabled
        enableToggleView.isSelected = toggleOption
        uiUpdatesAfterToggle()
        
        headerTitle.text = channelName
        enableToggleView.toggleTitleLabel.text = "Enable stream on".localized + " \(channelName)"
        channelTextView.formTextImageView.image = channelTypeData.image
        channelTextView.customTextLabel.text = "\(channelTypeData.staticDomainURL)"
        infoLabelView.formLabel.text = "You have to enter the".localized + " \(channelName) " + "stream URL here \"Click here to know more\"".localized
        infoLabelView.formLabel.highlight(searchedText: "Click here to know more".localized, color: UIColor.colorWithHex(color: "#0A11D5"))
        
    }
    
    func uiUpdatesAfterToggle(){
        if toggleOption {
            contentStackView.isHidden = false
        } else {
            contentStackView.isHidden = true
        }
    }
    
    // MARK: - ACTIONS
    
    @objc func enableToggleButtonTapped(){
        toggleOption = !toggleOption
        enableToggleView.isSelected = toggleOption
        uiUpdatesAfterToggle()
    }
    
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveButtonTapped(){
        
        guard let restreamViewModel,
              let restreamChannelData
        else { return }
        
        let channelId = restreamChannelData.channelId.unwrap
        let rtmpURL = rtmpURLView.formTextView.inputTextField.text ?? ""
        let streamKey = streamKeyView.formTextView.inputTextField.text ?? ""
        
        if rtmpURL.isEmpty {
            self.ism_showAlert("Error", message: "RTMP url is missing".localized + "!")
            return
        }
        
        if streamKey.isEmpty {
            self.ism_showAlert("Error", message: "Stream Key is missing".localized + "!")
            return
        }
        
        let ingestURL = rtmpURL + "/" + streamKey
        let channelType = RestreamChannelType(rawValue: restreamChannelData.channelType ?? 5) ?? .custom
        let channelName = restreamChannelData.channelName ?? ""
        
        DispatchQueue.main.async {
            CustomLoader.shared.startLoading()
        }
        
        print("INGEST URL ::: \(ingestURL)")
        
        // if channelId is empty create otherwise update
        if channelId == "" {
            restreamViewModel.addRestreamChannels(ingestUrl: ingestURL, enabled: toggleOption, channelType: channelType, channelName: channelName) { success, error in
                
                CustomLoader.shared.stopLoading()
                
                if error == nil {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.view.showToast(message: "\(error ?? "")")
                }
            }
        } else {
            
            restreamViewModel.updateRestreamChannels(ingestUrl: ingestURL, enabled: toggleOption, channelName: channelName, channelId: channelId, channelType: channelType) { success, error in
                
                CustomLoader.shared.stopLoading()
                
                if error == nil {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.view.showToast(message: "\(error ?? "")")
                }
            }
            
        }
        
    }

    @objc func infoLabelTapped(){
        
        guard let restreamChannelData
        else { return }
        
        let channelType = restreamChannelData.channelType.unwrap
        let restreamChannelType = RestreamChannelType(rawValue: channelType) ?? .custom
        
        var helpLink = ""
        
        switch restreamChannelType {
        case .facebook:
            helpLink = "https://support.stageten.tv/en/articles/3981648-streaming-to-facebook-via-rtmp"
        case .youtube:
            helpLink = "https://support.switcherstudio.com/en/articles/3553932-streaming-to-youtube-using-custom-rtmp"
        case .twitch:
            helpLink = "https://help.pexip.com/service/stream-twitch.htm"
        case .twitter:
            helpLink = "https://help.twitter.com/en/using-twitter/how-to-use-live-producer#RTMP"
        case .linkedin:
            helpLink = "https://www.linkedin.com/help/linkedin/answer/128901/go-live-using-a-custom-stream-rtmp-?lang=en"
        case .custom:
            // for instagram
            // https://about.instagram.com/blog/tips-and-tricks/instagram-live-producer
            helpLink = "http://surl.li/lcjbn"
        }
        
        // open a browser
        guard let url = URL(string: helpLink) else { return }
        UIApplication.shared.open(url)
        
    }
    
    @objc func showStreamKeyTapped(){
        
        secureEntry = !secureEntry
        streamKeyView.formTextView.inputTextField.isSecureTextEntry = secureEntry
        
        if secureEntry {
            streamKeyView.formTextView.copyButton.imageView?.tintColor = .lightGray.withAlphaComponent(0.6)
        } else {
            streamKeyView.formTextView.copyButton.imageView?.tintColor = .white
        }
        
    }
}
