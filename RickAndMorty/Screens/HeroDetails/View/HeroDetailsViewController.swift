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
        navigationItem.title = viewModel.hero?.name
    }
    
    // MARK: - Network
    
    private func fetchData() {
        if let id = viewModel.hero?.id {
            viewModel.fetchData(id: id)
        }
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
        viewModel.$isLoading.receive(on: RunLoop.main).sink { [weak self] isLoading in
            guard let self = self else {
                return
            }
            isLoading ? self.startActivity() : self.stopActivity()
            self.tableView.reloadData()
        }.store(in: &subscriptions)
        
        viewModel.$error.receive(on: RunLoop.main).sink { [weak self] error in
            guard let self = self, let error = error else {
                return
            }
            self.showError(error)
        }.store(in: &subscriptions)
    }
}

// MARK: - UITableViewDataSource

extension HeroDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.isLoading ? 0 : 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.hero == nil ? 0 : 1
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
            if let viewModelHero = viewModel.hero {
                cell.setup(hero: viewModelHero)
            }
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
