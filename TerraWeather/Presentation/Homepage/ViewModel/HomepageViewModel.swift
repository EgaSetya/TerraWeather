//
//  HomepageViewModel.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 20/09/24.
//

import Combine

protocol HomepageViewModel: HomepageViewModelInput, HomepageViewModelOuput {}

protocol HomepageViewModelInput {
    init(repository: LocationRepository)
    
    func viewWillAppear()
    func refresh()
    func didSelectProvince(with id: Int)
    func didSelectCity(with id: Int)
}

protocol HomepageViewModelOuput {
    var shouldRefresh: AnyPublisher<Void, Never> { get }
    var viewState: HomepageViewState { get }
    
    var provinceNames: [String] { get }
    var provinceIds: [Int] { get }
    var cityNames: [String] { get }
    var cityIds: [Int] { get }
    
    func validateFields(username: String?, province: String?, city: String?) -> (Bool, String?)
}

final class DefaultHomepageViewModel: HomepageViewModel {
    var viewState: HomepageViewState = .idle
    
    var cityNames: [String] = []
    var cityIds: [Int] = []
    
    private var provinces: [Province] = []
    private var cities: [City] = []
    private var selectedCity: City?
    
    private let _shouldRefresh = CurrentValueSubject<Void, Never>(())
    private let repository: LocationRepository
    
    init(repository: LocationRepository) {
        self.repository = repository
    }
    
    private func getProvinces() async {
        let result = await repository.getProvinces()
        
        switch result {
        case .success(let provinces):
            self.provinces = provinces
        case .failure(let failure):
            if failure == NetworkError.Offline {
                updateViewState(.connectionError(message: failure.errorDescription ?? ""))
                break
            }
            
            updateViewState(.error(message: failure.errorDescription ?? ""))
        }
    }
    
    private func getCities() async {
        let result = await repository.getCities()
        
        switch result {
        case .success(let cities):
            self.cities = cities
        case .failure(let failure):
            if failure == NetworkError.Offline {
                updateViewState(.connectionError(message: failure.errorDescription ?? ""))
                break
            }
            
            updateViewState(.error(message: failure.errorDescription ?? ""))
        }
    }
    
    private func getLocationData() {
        updateViewState(.loading)
        
        Task {
            await getProvinces()
            await getCities()
            
            updateViewState(.dataRetrieved)
        }
    }
    
    private func updateViewState(_ newState: HomepageViewState) {
        viewState = newState
        _shouldRefresh.send()
    }
}

// MARK: HomepageViewModelInput
extension DefaultHomepageViewModel {
    func viewWillAppear() {
        getLocationData()
    }
    
    func refresh() {
        getLocationData()
    }
    
    func didSelectProvince(with id: Int) {
        let filteredCities = cities.filter { $0.provinceId == "\(id)" }
        cityNames = filteredCities.compactMap { $0.name }
        cityIds = filteredCities.compactMap { Int($0.id) }
        
        updateViewState(.provinceSelected)
    }
    
    func didSelectCity(with id: Int) {
        selectedCity = cities.first { $0.id == "\(id)" }
    }
}

// MARK: HomepageViewModelOutput
extension DefaultHomepageViewModel {
    var shouldRefresh: AnyPublisher<Void, Never> {
        _shouldRefresh.eraseToAnyPublisher()
    }
    
    var provinceNames: [String] {
        provinces.compactMap { $0.name }
    }
    
    var provinceIds: [Int] {
        provinces.compactMap { Int($0.id) ?? 0 }
    }
    
    func validateFields(username: String?, province: String?, city: String?) -> (Bool, String?) {
        guard let username = username?.trimmingCharacters(in: .whitespacesAndNewlines), !username.isEmpty else {
            return (false, "You need to fill all fields!")
        }

        guard let province = province?.trimmingCharacters(in: .whitespacesAndNewlines), !province.isEmpty else {
            return (false, "You need to fill all fields!")
        }

        guard let city = city?.trimmingCharacters(in: .whitespacesAndNewlines), !city.isEmpty else {
            return (false, "You need to fill all fields!")
        }

        if username.count <= 3 {
            return (false, "Username must be more than 3 characters!")
        }

        return (true, nil)
    }
}
