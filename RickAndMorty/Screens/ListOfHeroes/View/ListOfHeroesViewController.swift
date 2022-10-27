//
//  ListOfHeroesViewController.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 26.10.2022.
//

import UIKit
import Combine

final class ListOfHeroesViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var tableView: UITableView!

    // MARK: - Properties
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - ViewModel
    
    private var viewModel: ListOfHeroesViewModel!
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureObserver()
        fetchData()
        navigationItem.title = viewModel.titlePage
    }
    
    // MARK: - Configure
    
    func configure(with viewModel: ListOfHeroesViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Network
    
    private func fetchData() {
        viewModel.fetchData()
        tableView.setContentOffset(.zero, animated: true)
    }
    
    // MARK: - Configure
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Observer
    
    private func configureObserver() {        
        viewModel.$heroes.receive(on: RunLoop.main).sink { [weak self] _ in
            guard let self = self else {
                return
            }
            self.tableView.reloadData()
        }.store(in: &subscriptions)
        
        let stateHandler: (ViewModelState) -> Void = { [weak self] state in
            guard let self = self else {
                return
            }
            switch state {
            case .loading:
                self.startActivity()
            case .finished:
                self.stopActivity()
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
    
    // MARK: - Actions
    
    @IBAction private func refresh() {
        fetchData()
    }
}

// MARK: - UITableViewDataSource

extension ListOfHeroesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.heroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HeroTableViewCell.create(for: tableView) as! HeroTableViewCell
        cell.setup(hero: viewModel.heroes[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ListOfHeroesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        router.navigate(to: .heroDetails(hero: viewModel.heroes[indexPath.row]))
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.heroes.count - 1 == indexPath.row {
            viewModel.loadMoreItemsForList()
        }
    }
}
