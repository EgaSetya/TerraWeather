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
            // Check if the indicator is already present
            if self.view.viewWithTag(self.activityIndicatorTag) != nil {
                return
            }

            // Create a background view
            let backgroundView = UIView()
            backgroundView.tag = self.activityIndicatorTag
            backgroundView.backgroundColor = UIColor.white
            backgroundView.layer.cornerRadius = 10 // Optional: rounded corners
            backgroundView.clipsToBounds = true

            // Create and configure the activity indicator
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.hidesWhenStopped = true
            activityIndicator.color = .gray

            // Add the activity indicator to the background view
            backgroundView.addSubview(activityIndicator)

            // Add the background view to the main view
            self.view.addSubview(backgroundView)

            // Set up layout for the background view
            backgroundView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(120) // Set size as needed
            }

            // Set up layout for the activity indicator
            activityIndicator.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }

            // Ensure layout is updated before starting animation
            self.view.layoutIfNeeded()

            // Start animating
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
