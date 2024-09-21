//
//  ForecastTableViewCell.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 21/09/24.
//

import UIKit

import Kingfisher
import SnapKit

class ForecastTableViewCell: UITableViewCell {
    static let identifier = "ForecastTableViewCell"
    
    private lazy var cardContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        
        return view
    }()
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: WeatherItemViewModel) {
        dayLabel.text = viewModel.day
        iconImageView.kf.setImage(with: viewModel.iconURL)
        descriptionLabel.text = viewModel.weatherDescription
        temperatureLabel.text = "\(viewModel.temperature)° C"
    }
    
    private func setupLayout() {
        backgroundColor = .clear
        
        contentView.addSubview(cardContainerView)
        cardContainerView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.bottom.right.equalToSuperview().inset(10)
        }
        
        cardContainerView.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(16)
        }
        
        cardContainerView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(10)
            make.leading.equalTo(dayLabel)
            make.width.height.equalTo(80)
        }
        
        cardContainerView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
            make.centerY.equalTo(iconImageView)
        }
        
        cardContainerView.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(descriptionLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalTo(descriptionLabel)
        }
    }
}
