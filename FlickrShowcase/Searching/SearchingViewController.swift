//
//  SearchingViewController.swift
//  FlickrShowcase
//
//  Created by ShengHua Wu on 30/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import UIKit

final class SearchingViewController: UIViewController {
    // MARK: Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        tableView.tableHeaderView = self.searchBar
        tableView.sectionHeaderHeight = self.searchBar.frame.height
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        return searchBar
    }()
    
    var viewModel: SearchingViewModel!
    var didClickSearchButton: ((String) -> ())?
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = .bottom
        
        let cancelButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissAction(sender:)))
        navigationItem.leftBarButtonItem = cancelButtonItem
        
        view.addSubview(tableView)
        
        viewModel.fetchSearchHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerNotifications()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        unregisterNotifications()
    }
    
    // MARK: Actions
    func dismissAction(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Register & unregister notifications
    private func registerNotifications() {
        let center = NotificationCenter.default
        
        center.addObserver(with: UIViewController.keyboardWillShow) { (payload) in
            let contentInset = UIEdgeInsetsMake(0.0, 0.0, payload.endFrame.height, 0.0)
            self.tableView.contentInset = contentInset
            self.tableView.scrollIndicatorInsets = contentInset
        }
        
        center.addObserver(with: UIViewController.keyboardWillHide) { (payload) in
            let contentInset = UIEdgeInsets.zero
            self.tableView.contentInset = contentInset
            self.tableView.scrollIndicatorInsets = contentInset
        }
    }
    
    private func unregisterNotifications() {
        let center = NotificationCenter.default
        center.removeObserver(self, name: UIViewController.keyboardWillShow.name, object: nil)
        center.removeObserver(self, name: UIViewController.keyboardWillHide.name, object: nil)
    }
    
    // MARK: Public Methods
    func updateUI(with state: State<[String]>) {
        switch state {
        case .normal:
            tableView.reloadData()
        default:
            break
        }
    }
}

// MARK: - Table View Data Source
extension SearchingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.state.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
        cell.textLabel?.text = viewModel.state.element(at: indexPath.row)
        return cell
    }
}

// MARK: - Table View Delegate
extension SearchingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.state.element(at: indexPath.row).flatMap {
            didClickSearchButton?($0)
        }
    }
}

// MARK: - Search Bar Delegate
extension SearchingViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text.flatMap {
            viewModel.refreshSearchHistory(with: $0)
            didClickSearchButton?($0)
        }
    }
}
