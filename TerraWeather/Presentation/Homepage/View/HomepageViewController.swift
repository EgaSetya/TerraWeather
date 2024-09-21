//
//  HomepageViewController.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 19/09/24.
//

import UIKit
import Combine

import SnapKit
import iOSDropDown

enum HomepageViewState: Equatable {
    case idle
    case loading
    case dataRetrieved
    case provinceSelected
    case error(message: String)
    case connectionError(message: String)
}

struct HomepageActions {
    let showWeatherDetail: (_ selectedWeatherItem: WeatherDetailPayload) -> Void
    let showErrorAlert: (_ type: PopupAlertType, _ retryDidTap: (() -> Void)?) -> Void
}

final class HomepageViewController: UIViewController {
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "homepage_bg")
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.65
        
        return imageView
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "TerraWeather"
        label.font = .systemFont(ofSize: 42)
        label.textAlignment = .center
        label.textColor = UIColor(hex: "4fa2d1")
        
        return label
    }()
    
    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Input your name"
        
        return textField
    }()
    
    private lazy var provinceDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.borderStyle = .roundedRect
        dropDown.placeholder = "Select your province"
        dropDown.arrowSize = 0
        dropDown.checkMarkEnabled = false
        dropDown.selectedRowColor = .lightGray.withAlphaComponent(0.25)
        dropDown.didSelect { [weak self] selectedText, index, id in
            guard let self else {
                return
            }
            
            dropDown.selectedIndex = viewModel.provinceNames.firstIndex(of: selectedText) ?? 0
            viewModel.didSelectProvince(with: id)
            enableCityDropDown()
        }
        
        return dropDown
    }()
    
    private lazy var cityDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.borderStyle = .roundedRect
        dropDown.placeholder = "Select your city"
        dropDown.arrowSize = 0
        dropDown.checkMarkEnabled = false
        dropDown.selectedRowColor = .lightGray.withAlphaComponent(0.25)
        dropDown.didSelect { [weak self] selectedText, index, id in
            guard let self else {
                return
            }
            
            dropDown.selectedIndex = viewModel.cityNames.firstIndex(of: selectedText) ?? 0
            viewModel.didSelectCity(with: id)
        }
        
        return dropDown
    }()
    
    private lazy var checkWeatherButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.setTitle("Check Weather", for: .normal)
        button.backgroundColor = UIColor(hex: "4fa2d1")
        
        return button
    }()
    
    private let actions: HomepageActions
    private let viewModel: HomepageViewModel
    
    init(actions: HomepageActions, viewModel: HomepageViewModel) {
        self.actions = actions
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.viewWillAppear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        bindViewModel()
        
        setupLayout()
        
        disableCityDropDown()
        addTarget()
    }
    
    private func setupLayout() {
        view.backgroundColor = .black
        
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        view.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).inset(20)
            make.height.equalTo(60)
        }
        
        view.addSubview(usernameTextField)
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(40)
            make.leading.equalTo(view).offset(50)
            make.trailing.equalTo(view).inset(50)
        }
        
        view.addSubview(provinceDropDown)
        provinceDropDown.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(20)
            make.leading.equalTo(usernameTextField)
            make.trailing.equalTo(usernameTextField)
            make.height.equalTo(40)
        }
        
        view.addSubview(cityDropDown)
        cityDropDown.snp.makeConstraints { make in
            make.top.equalTo(provinceDropDown.snp.bottom).offset(20)
            make.leading.equalTo(usernameTextField)
            make.trailing.equalTo(usernameTextField)
            make.height.equalTo(40)
        }
        
        view.addSubview(checkWeatherButton)
        checkWeatherButton.snp.makeConstraints { make in
            make.top.equalTo(cityDropDown.snp.bottom).offset(30)
            make.leading.equalTo(usernameTextField)
            make.trailing.equalTo(usernameTextField)
            make.height.equalTo(50)
        }
    }
    
    private func addTarget() {
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        checkWeatherButton.addTarget(self, action: #selector(checkWeatherButtonTapped), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        viewModel
            .shouldRefresh
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.observeViewState()
            }.store(in: &cancellables)
    }
    
    private func observeViewState() {
        switch viewModel.viewState {
        case .idle, .loading:
            showActivityIndicator()
        case .dataRetrieved:
            refreshProvinceDropDown()
            hideActivityIndicator()
        case .provinceSelected:
            refreshCityDropDown()
            hideActivityIndicator()
        case .error(let message):
            handleError(message)
            hideActivityIndicator()
        case .connectionError(let message):
            handleConnectionError(message)
            hideActivityIndicator()
        }
    }
    
    private func handleError(_ message: String) {
        actions.showErrorAlert(.commonError(message: message)) { [weak self] in
            guard let self else {
                return
            }
            
            viewModel.refresh()
        }
    }
    
    private func handleConnectionError(_ message: String) {
        actions.showErrorAlert(.connectionError(message: message)) { [weak self] in
            guard let self else {
                return
            }
            
            viewModel.refresh()
        }
    }
    
    private func refreshProvinceDropDown() {
        provinceDropDown.optionArray = viewModel.provinceNames
        provinceDropDown.optionIds = viewModel.provinceIds
    }
    
    private func refreshCityDropDown() {
        cityDropDown.optionArray = viewModel.cityNames
        cityDropDown.optionIds = viewModel.cityIds
    }
    
    private func enableCityDropDown() {
        cityDropDown.isUserInteractionEnabled = true
        cityDropDown.backgroundColor = .white
    }
    
    private func disableCityDropDown() {
        cityDropDown.isUserInteractionEnabled = false
        cityDropDown.backgroundColor = .gray.withAlphaComponent(0.75)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel.didChangeUsername(with: textField.text ?? "")
    }
    
    @objc func checkWeatherButtonTapped() {
        let validationResult = viewModel.validateFields(username: usernameTextField.text, province: provinceDropDown.text, city: cityDropDown.text)
        let textValidation: (isValid: Bool, errorMessage: String?) = validationResult
        
        if textValidation.isValid {
            actions.showWeatherDetail(viewModel.selectedWeatherItemViewModel)
        } else {
            actions.showErrorAlert(.validationError(message: textValidation.errorMessage ?? ""), nil)
        }
    }
}
