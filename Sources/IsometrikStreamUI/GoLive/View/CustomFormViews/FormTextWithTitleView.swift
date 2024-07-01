//
//  FormTextWithTitleView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 08/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

class FormTextWithTitleView: UIView {

    // MARK: - PROPERTIES
    
    let formTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Form Title Text".localized
        label.font = Appearance.default.font.getFont(forTypo: .h6)
        label.textColor = .white
        return label
    }()
    
    let formTextView: FormTextView = {
        let view = FormTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        addSubview(formTitleLabel)
        addSubview(formTextView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            formTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            formTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            formTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            formTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            formTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            formTextView.heightAnchor.constraint(equalToConstant: 45),
            formTextView.topAnchor.constraint(equalTo: formTitleLabel.bottomAnchor, constant: 5)
        ])
    }

}
