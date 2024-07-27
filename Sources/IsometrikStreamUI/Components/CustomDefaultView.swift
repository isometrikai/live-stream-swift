//import UIKit
//
//class CustomDefaultView: UIView {
//
//    // MARK: - PROPERTIES
//    
//    let stackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.distribution = .fillProportionally
//        stackView.axis = .vertical
//        return stackView
//    }()
//    
//    let defaultImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//    
//    lazy var defaultTitleLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = ""
//        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
//        label.textColor = .black
//        label.textAlignment = .center
//        label.numberOfLines = 0
//        return label
//    }()
//    
//    // MARK: - MAIN
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//        setupConstraints()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - FUNCTIONS
//    
//    func setupViews(){
//        addSubview(stackView)
//        stackView.addArrangedSubview(defaultImageView)
//        stackView.addArrangedSubview(defaultTitleLabel)
//    }
//    
//    func setupConstraints(){
//        NSLayoutConstraint.activate([
//            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
//            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            
//            defaultImageView.widthAnchor.constraint(equalToConstant: 70),
//            defaultImageView.heightAnchor.constraint(equalToConstant: 70),
//            
//            defaultTitleLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.8),
//            defaultTitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: stackView.leadingAnchor),
//            defaultTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: stackView.trailingAnchor)
//        ])
//    }
//
//}


import UIKit

class CustomPlaceholderView: UIView {

    // MARK: - Properties
    private let imageView: UIImageView
    private let label: UILabel

    // MARK: - Initializer
    override init(frame: CGRect) {
        imageView = UIImageView()
        label = UILabel()

        super.init(frame: frame)

        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        imageView = UIImageView()
        label = UILabel()

        super.init(coder: coder)

        setupView()
        setupConstraints()
    }

    // MARK: - Setup Methods
    private func setupView() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),

            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }

    // MARK: - Public Methods
    func configure(image: UIImage?, text: String?, font: UIFont?, color: UIColor?) {
        imageView.image = image
        label.text = text
        label.font = font
        label.textColor = color
    }
}
