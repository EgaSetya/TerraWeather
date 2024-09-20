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
}

protocol HomepageViewModelOuput {}

final class DefaultHomepageViewModel: HomepageViewModel {
    private let repository: LocationRepository
    
    init(repository: LocationRepository) {
        self.repository = repository
    }
}

extension DefaultHomepageViewModel {
    func viewWillAppear() {
        Task {
            let result = await repository.getProvinces()
            
            switch result {
            case .success(let provinces):
                print(provinces)
            case .failure(let failure):
                print(failure.errorDescription)
            }
        }
    }
}
