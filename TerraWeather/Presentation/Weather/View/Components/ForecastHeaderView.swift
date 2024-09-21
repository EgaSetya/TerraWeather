//
//  ForecastHeaderView.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 21/09/24.
//

import UIKit

import SnapKit

class ForecastHeaderView: UIView {
    
    private let calendarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = .darkGray
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "5-DAY FORECAST"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(calendarImageView)
        calendarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(24)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(calendarImageView.snp.trailing).offset(8)
            make.centerY.equalTo(calendarImageView)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}
