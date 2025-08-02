//
//  UserListViewController.swift
//  AllInApi
//
//  Created by Archisman on 01/08/25.
//

import UIKit
import Combine

class UserListViewController: UIViewController {
    
    private let loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.color = .gray
        return loader
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UserListTableViewCell.self, forCellReuseIdentifier: "UserCell")
        tableView.tableFooterView = nil
        tableView.tableHeaderView = nil
        return tableView
    }()
    
    private var headerView: UIView?
    
    var cancellables = Set<AnyCancellable>()
    var viewModel: UserListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
        setConstraints()
        bindViewModel()
        
        Task {
            await viewModel?.fetchUsers()
        }
    }
    
    fileprivate func setupUI() {
        view.addSubview(tableView)
        view.addSubview(loader)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    fileprivate func setConstraints() {
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    fileprivate func bindViewModel() {
        viewModel?.$users
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel?.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.loader.isHidden = !isLoading
                isLoading ? self?.loader.startAnimating() : self?.loader.stopAnimating()
                self?.setPaginationFooterView(isLoading)
            }
            .store(in: &cancellables)
        
        viewModel?.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let self = self else { return }
                guard let message = errorMessage else { return }
                AlertManager.showConfirmationAlert(
                    onViewController: self,
                    title: "Error",
                    message: message,
                    yesButtonTitle: "Retry",
                    noButtonTitle: "Cancel",
                    yesCompletion: {
                        Task {
                            await self.viewModel?.fetchUsers()
                        }
                    },
                    noCompletion: nil
                )
            }
            .store(in: &cancellables)
    }
    
    private func setPaginationFooterView(_ isLoading: Bool) {
        if isLoading && viewModel?.users.count ?? 0 > 0 {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50)
            spinner.color = .gray
            spinner.startAnimating()
            tableView.tableFooterView = spinner
        } else {
            tableView.tableFooterView = nil
        }
    }
}

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard viewModel?.users.count ?? 0 > 0 else { return nil }
        
        if headerView == nil {
            let header = UIView()
            header.backgroundColor = .systemGray6
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "User List"
            label.font = .boldSystemFont(ofSize: 16)
            label.textColor = .darkGray
            
            header.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 8),
                label.centerYAnchor.constraint(equalTo: header.centerYAnchor)
            ])
            
            headerView = header
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.users.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserListTableViewCell,
            let vm = viewModel
        else {
            return UITableViewCell()
        }
        
        cell.configureCell(user: vm.users[indexPath.row])
        return cell
    }
    
    /*
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
     guard let vm = viewModel else { return }
     
     if indexPath.row == vm.users.count - 1 {
     Task {
     await vm.fetchUsers()
     }
     }
     }
     */
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let viewModel = viewModel else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.frame.size.height
        
        // When user scrolls near the bottom (within 1.5x of visible area)
        let shouldFetchMore = offsetY > contentHeight - visibleHeight * 1.5
        if shouldFetchMore && !viewModel.isPaginating && !viewModel.isLoading && viewModel.users.count > 0 {
            Task {
                await viewModel.fetchUsers()
            }
        }
    }
}
