//
//  ListViewController.swift
//  CombineIntro
//
//  Created by Tony on 2023-04-01.
//

import UIKit
import SnapKit
import Combine

class ListViewController: UIViewController {
    
    private(set) var viewModel: ListViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: BaseViewModel = ListViewModel()) {
        self.viewModel = viewModel as! ListViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
//        setupBinding()
        
        refreshControl.beginRefreshing()
        loadData()
    }
    
    private func setupBinding() {
        viewModel.dataSourceV2.sink { [weak self] (_) in
            self?.endRefreshing()
        }.store(in: &subscriptions)
    }
    
    private func setupUI() {
        title = "Coin List"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func loadData() {
        viewModel.fetchCoinListV0 { [weak self] in
            self?.endRefreshing()
        }
//        viewModel.fetchCoinListV2()
    }
    
    private func endRefreshing() {
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        loadData()
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.addSubview(refreshControl)
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceV0.count
//        return viewModel.dataSourceV2.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CoinCell.cell(withTableView: tableView)
        let dataSource = viewModel.dataSourceV0
//        let dataSource = viewModel.dataSourceV2.value
        cell.updateModel(coin: dataSource[indexPath.row], index: indexPath)
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
