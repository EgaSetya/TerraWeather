//
//  HomepageViewController.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 19/09/24.
//

import UIKit

struct HomepageActions {
    let showWeatherDetail: () -> Void
}

class HomepageViewController: UIViewController {
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
        viewModel.viewWillAppear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }
}

