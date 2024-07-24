//
//  RTMPIngestViewController.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 30/08/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

class RTMPIngestViewController: UIViewController, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "RTMP ingest details"
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h3)
        label.textAlignment = .center
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You can livestream from third-party RTMP software such as OBS, using the provided ingest URL."
        label.textColor = .lightGray
        label.font = appearance.font.getFont(forTypo: .h8)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // BOTTOM VIEW
    
    let rtmpURLView: FormTextWithTitleView = {
        let view = FormTextWithTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.formTitleLabel.text = "RTMP URL"
        view.formTextView.customTextLabel.text = "rtmp://rtmp.isometrik.io"
        view.formTextView.customTextLabel.textColor = .white
        view.formTextView.copyButton.isHidden = false
        return view
    }()
    
    let streamKeyView: FormTextWithTitleView = {
        let view = FormTextWithTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.formTitleLabel.text = "Stream Key"
        view.formTextView.customTextLabel.textColor = .white
        view.formTextView.customTextLabel.text = ""
        return view
    }()
    
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.5)
        return view
    }()
    
    // MARK: - MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        view.backgroundColor = appearance.colors.appDarkGray
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(bottomView)
        bottomView.addSubview(dividerView)
        
        bottomView.addSubview(stackView)
        stackView.addArrangedSubview(rtmpURLView)
        stackView.addArrangedSubview(streamKeyView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 200),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: bottomView.safeAreaLayoutGuide.bottomAnchor),
            
            rtmpURLView.heightAnchor.constraint(equalToConstant: 70),
            streamKeyView.heightAnchor.constraint(equalToConstant: 70),
            
            dividerView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            dividerView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25)
        ])
    }
    
    func configureData(streamData: ISMStream?){
        guard let streamData else { return }
        
        let streamKey = streamData.streamKey.unwrap
        let ingestEndpoint = streamData.ingestEndpoint.unwrap
        
        rtmpURLView.formTextView.customTextLabel.text = ingestEndpoint
        rtmpURLView.formTextView.copyButton.isHidden = false
        
        rtmpURLView.formTextView.copyButton.addTarget(self, action: #selector(copyRTMPURLTapped), for: .touchUpInside)
        
        streamKeyView.formTextView.customTextLabel.text = streamKey
        streamKeyView.formTextView.copyButton.isHidden = false
        
        streamKeyView.formTextView.copyButton.addTarget(self, action: #selector(copyStreamKeyTapped), for: .touchUpInside)
        
    }
    
    @objc func copyStreamKeyTapped(){
        // write to clipboard
        UIPasteboard.general.string = streamKeyView.formTextView.customTextLabel.text ?? ""

        self.view.showToast(message:"Stream Key Copied!" )

    }
    
    @objc func copyRTMPURLTapped(){
        // write to clipboard
        UIPasteboard.general.string = rtmpURLView.formTextView.customTextLabel.text ?? ""
        
        // copied animation
        self.view.showToast(message:"RTMP URL Copied!" )
    }

}
