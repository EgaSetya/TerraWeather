//
//  UIViewController+ActivityIndicator.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 20/09/24.
//

import UIKit

import SnapKit

extension UIViewController {
    private var activityIndicatorTag: Int { return 999999 }
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            if self.view.viewWithTag(self.activityIndicatorTag) != nil {
                return
            }

            let backgroundView = UIView()
            backgroundView.tag = self.activityIndicatorTag
            backgroundView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            backgroundView.layer.cornerRadius = 10
            backgroundView.clipsToBounds = true

            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.hidesWhenStopped = true
            activityIndicator.color = .darkGray

            backgroundView.addSubview(activityIndicator)

            self.view.addSubview(backgroundView)

            backgroundView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(120)
            }

            activityIndicator.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }

            self.view.layoutIfNeeded()

            activityIndicator.startAnimating()
        }
    }

    func hideActivityIndicator() {
        DispatchQueue.main.async {
            if let backgroundView = self.view.viewWithTag(self.activityIndicatorTag) {
                backgroundView.removeFromSuperview()
            }
        }
    }
}
