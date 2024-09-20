//
//  PopUpAlertViewController.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 20/09/24.
//

import UIKit

import SnapKit

enum PopupAlertType {
    case commonError(message: String)
    case connectionError(message: String)
    case validationError(message: String)
}

final class PopupAlertViewController: UIViewController {
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        
        return view
    }()
    
    private let symbolImageViewConfig = UIImage.SymbolConfiguration(hierarchicalColor: .systemPink)
    
    private lazy var  symbolImageView: UIImageView = {
        let image = UIImage(systemName: "exclamationmark.circle.fill", withConfiguration: symbolImageViewConfig)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var  messageLabel: UILabel = {
        let label = UILabel()
        label.text = "This is an alert message!This is an alert message!This is an alert message!This is an alert message!This is an alert message!This is an alert message!"
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var  retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("RETRY", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    private let type: PopupAlertType
    private let retryDidTap: (() -> Void)?
    
    init(type: PopupAlertType, retryDidTap: (() -> Void)?) {
        self.type = type
        self.retryDidTap = retryDidTap
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        setupLayout()
        addTarget()
    }
    
    func setupLayout() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        view.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(300)
        }
        
        cardView.addSubview(symbolImageView)
        symbolImageView.snp.makeConstraints { make in
            make.top.equalTo(cardView).offset(20)
            make.centerX.equalTo(cardView)
            make.width.height.equalTo(125)
        }
        
        cardView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(symbolImageView.snp.bottom).offset(10)
            make.left.right.equalTo(cardView).inset(20)
        }
        
        cardView.addSubview(retryButton)
        retryButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.bottom.equalTo(cardView.snp.bottom).inset(20)
            make.leading.equalTo(cardView).offset(20)
            make.trailing.equalTo(cardView).inset(20)
            make.height.equalTo(40)
        }
        
        updateViewsByType()
    }
    
    private func updateViewsByType() {
        switch type {
        case .commonError(let message):
            messageLabel.text = message
            symbolImageView.image = UIImage(systemName: "exclamationmark.circle.fill", withConfiguration: symbolImageViewConfig)
            retryButton.setTitle("RETRY", for: .normal)
        case .connectionError(let message):
            messageLabel.text = message
            symbolImageView.image = UIImage(systemName: "wifi.slash", withConfiguration: symbolImageViewConfig)
            retryButton.setTitle("RETRY", for: .normal)
        case .validationError(let message):
            messageLabel.text = message
            symbolImageView.image = UIImage(systemName: "text.badge.xmark", withConfiguration: symbolImageViewConfig)
            retryButton.setTitle("OK", for: .normal)
        }
    }
    
    private func addTarget() {
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func retryButtonTapped() {
        dismiss(animated: true, completion: nil)
        
        retryDidTap?()
    }
    
    @objc func backgroundTapped() {
        dismiss(animated: true, completion: nil)
    }
}
