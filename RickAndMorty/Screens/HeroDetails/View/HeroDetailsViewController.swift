//
//  HeroDetailsViewController.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 26.10.2022.
//

import UIKit
import Combine

final class HeroDetailsViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Properties
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - ViewModel
    
    private var viewModel: HeroDetailViewModel!
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureObserver()
        fetchData()
        navigationItem.title = viewModel.hero.name
    }
    
    // MARK: - Network
    
    private func fetchData() {
        viewModel.fetchData()
    }
    
    // MARK: - Configure
    
    func configure(with viewModel: HeroDetailViewModel) {
        self.viewModel = viewModel
    }
    
    private func configureTableView() {
        tableView.dataSource = self
    }

    // MARK: - Observer
    
    private func configureObserver() {
        let stateHandler: (ViewModelState) -> Void = { [weak self] state in
            guard let self = self else {
                return
            }
            switch state {
            case .loading:
                self.startActivity()
            case .finished:
                self.stopActivity()
                self.tableView.reloadData()
            case .error(let error):
                self.stopActivity()
                self.showError(error)
            }
        }
        
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink(receiveValue: stateHandler)
            .store(in: &subscriptions)
    }
}

// MARK: - UITableViewDataSource

extension HeroDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.state == .finished ? 3 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return viewModel.location == nil ? 0 : 1
        case 2:
            return viewModel.episodes.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = HeroDetailsNameTableViewCell.create(for: tableView) as! HeroDetailsNameTableViewCell
            cell.setup(hero: viewModel.hero)
            return cell
        case 1:
            let cell = HeroDetailsLocationTableViewCell.create(for: tableView) as! HeroDetailsLocationTableViewCell
            if let location = viewModel.location {
                cell.setup(location: location)
            }
            return cell
        case 2:
            let cell = HeroDetailsEpisodeTableViewCell.create(for: tableView) as! HeroDetailsEpisodeTableViewCell
            cell.setup(with: viewModel.episodes[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
}
