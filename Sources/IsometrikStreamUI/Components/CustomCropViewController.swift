//
//  CustomCropViewController.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 06/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

class CustomCropViewController: UIViewController, UIScrollViewDelegate, ISMAppearanceProvider {
    
    var croppedImage: ((UIImage?) -> Void)?
    var aspectW: CGFloat!
    var aspectH: CGFloat!
    var img: UIImage!
    
    var imageView: UIImageView!
    var scrollView: UIScrollView!
    
    var closeButton: UIButton!
    var cropButton: UIButton!
    
    // - action stack
    
    let actionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("cancel".localized, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h5)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(tappedClose), for: .touchUpInside)
        button.ismTapFeedBack()
        return button
    }()
    
    lazy var chooseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("choose", for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h5)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 25
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(tappedCrop), for: .touchUpInside)
        button.ismTapFeedBack()
        return button
    }()
    
    //:

    var holeRect: CGRect!

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init(frame: CGRect, image: UIImage, aspectWidth: CGFloat, aspectHeight: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        aspectW = aspectWidth
        aspectH = aspectHeight
        img = image
        view.frame = frame
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        
        if img.imageOrientation != .up {
          UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
          var rect = CGRect.zero
          rect.size = img.size
          img.draw(in: rect)
          img = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
        }

        view.backgroundColor = UIColor.gray

        // TODO: improve to handle super tall aspects (this one assumes full width)
        let holeWidth = view.frame.width
        let holeHeight = holeWidth * aspectH/aspectW
        holeRect = CGRect(x: 0, y: view.frame.height/2-holeHeight/2, width: holeWidth, height: holeHeight)
      
        imageView = UIImageView(image: img)
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.addSubview(imageView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        view.addSubview(scrollView)

        let minZoom = max(holeWidth / img.size.width, holeHeight / img.size.height)
        scrollView.minimumZoomScale = minZoom
        scrollView.zoomScale = minZoom
        scrollView.maximumZoomScale = minZoom*4

        let viewFinder = hollowView(frame: view.frame, transparentRect: holeRect)
        view.addSubview(viewFinder)
        
        // - action button
        
        view.addSubview(actionStackView)
        actionStackView.addArrangedSubview(cancelButton)
        actionStackView.addArrangedSubview(chooseButton)
        
        NSLayoutConstraint.activate([
            actionStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            actionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            actionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            actionStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        //:
        
    }

    // MARK: scrollView delegate

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let gapToTheHole = view.frame.height/2-holeRect.height/2
        scrollView.contentInset = UIEdgeInsets(top: gapToTheHole, left: 0, bottom: gapToTheHole, right: 0)
    }

    // MARK: actions
  
    @objc func tappedClose() {
        print("tapped close")
        self.dismiss(animated: true, completion: nil)
    }
  
    @objc func tappedCrop() {
        print("tapped crop")

        var imgX: CGFloat = 0
        if scrollView.contentOffset.x > 0 {
            imgX = scrollView.contentOffset.x / scrollView.zoomScale
        }

        let gapToTheHole = view.frame.height/2 - holeRect.height/2
        var imgY: CGFloat = 0
        if scrollView.contentOffset.y + gapToTheHole > 0 {
            imgY = (scrollView.contentOffset.y + gapToTheHole) / scrollView.zoomScale
        }

        let imgW = holeRect.width  / scrollView.zoomScale
        let imgH = holeRect.height  / scrollView.zoomScale

        print("IMG x: \(imgX) y: \(imgY) w: \(imgW) h: \(imgH)")

        let cropRect = CGRect(x: imgX, y: imgY, width: imgW, height: imgH)
        let imageRef = img.cgImage!.cropping(to: cropRect)
        let croppedImage = UIImage(cgImage: imageRef!)

        self.croppedImage?(croppedImage)

        self.dismiss(animated: true, completion: nil)
    }
  
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if error == nil {
            print("saved cropped image")
        } else {
            print("error saving cropped image")
        }
    }
  
}


// MARK: hollow view class

class hollowView: UIView {
    
    var transparentRect: CGRect!

    let borderedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        return view
    }()

    init(frame: CGRect, transparentRect: CGRect) {
        super.init(frame: frame)
        self.transparentRect = transparentRect
        self.isUserInteractionEnabled = false
        self.alpha = 0.6
        self.isOpaque = false
        borderedView.frame = transparentRect
        addSubview(borderedView)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        backgroundColor?.setFill()
        UIRectFill(rect)
        let holeRectIntersection = transparentRect.intersection(rect)
        UIColor.clear.setFill();
        UIRectFill(holeRectIntersection);
    }
    
}

