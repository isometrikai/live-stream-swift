
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
