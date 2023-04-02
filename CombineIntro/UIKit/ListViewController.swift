//
//  ListViewController.swift
//  CombineIntro
//
//  Created by Tony on 2023-04-01.
//

import UIKit
import SnapKit

class ListViewController: UIViewController {
    
    private(set) var viewModel: ListViewModel
    
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
        
        loadData()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func loadData() {
        viewModel.fetchCoinList { [weak self] in
            self?.tableView.reloadData()
        }
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        return tableView
    }()
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CoinCell.cell(withTableView: tableView)
        cell.coinModel = viewModel.dataSource[indexPath.row]
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
