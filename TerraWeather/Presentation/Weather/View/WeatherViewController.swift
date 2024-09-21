//
//  WeatherViewController.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 21/09/24.
//

import UIKit

import SnapKit

enum WeatherViewState: Equatable {
    case idle
    case loading
    case dataRetrieved
    case error(message: String)
    case connectionError(message: String)
}

struct WeatherActions {
    let showErrorAlert: (_ type: PopupAlertType, _ retryDidTap: (() -> Void)?) -> Void
}

final class WeatherViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.identifier)
        
        return tableView
    }()
    
    private let actions: WeatherActions
    private let viewModel: WeatherViewModel
    
    init(actions: WeatherActions, viewModel: WeatherViewModel) {
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
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
            tableView.reloadData()
            hideActivityIndicator()
        case .error(let message):
            handleError(message)
            hideActivityIndicator()
        case .connectionError(let message):
            handleError(message)
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
}

extension WeatherViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 2 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return viewModel.forecastItemViewModels.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath) as? ForecastTableViewCell {
                cell.configure(with: viewModel.forecastItemViewModels[indexPath.row])
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = GreetingHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 200), viewModel: viewModel.currentWeatherItemViewModel)
           
            return headerView
        } else if section == 1 {
            let headerView = ForecastHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 80))
           
            return headerView
        }
        
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
}
