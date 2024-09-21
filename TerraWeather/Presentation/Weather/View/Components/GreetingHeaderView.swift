//
//  GreetingHeaderView.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 21/09/24.
//

import UIKit

import SnapKit

import UIKit
import SnapKit

class GreetingHeaderView: UIView {
    private lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()

    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()

    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()

    private lazy var weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let viewModel: WeatherItemViewModel?

    init(frame: CGRect, viewModel: WeatherItemViewModel?) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupLayout()
        
        configureWithViewModel()
    }

    private func setupLayout() {
        self.backgroundColor = .systemBlue
        
        addSubview(greetingLabel)
        greetingLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }
        
        addSubview(cityLabel)
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(greetingLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }
        
        addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }
        
        addSubview(weatherDescriptionLabel)
        weatherDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    private func configureWithViewModel() {
        guard let viewModel else {
            return
        }
        
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            greetingLabel.text = "Good Morning, \(viewModel.username)!"
        case 12..<17:
            greetingLabel.text = "Good Afternoon, \(viewModel.username)!"
        case 17..<21:
            greetingLabel.text = "Good Evening, \(viewModel.username)!"
        default:
            greetingLabel.text = "Good Night, \(viewModel.username)!"
        }

        cityLabel.text = viewModel.city
        temperatureLabel.text = "\(Int(viewModel.temperature))°"
        weatherDescriptionLabel.text = viewModel.weatherDescription
    }
}

