//
//  Components.swift
//  CombineIntro
//
//  Created by Tony on 2023-04-01.
//

import UIKit

class CoinCell: UITableViewCell {
    
    private(set) var coinModel: CoinModel?
    
    static func cell(withTableView tableView: UITableView) -> CoinCell {
        let cellIdentifier = "\(String(describing: Self.self))Identifier"
        
        var cell: CoinCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CoinCell
        if cell == nil {
            cell = CoinCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        return cell!
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateModel(coin: CoinModel?, index: IndexPath) {
        self.coinModel = coin
        if let name = coin?.name {
            textLabel?.text = "\(index.row + 1) - \(name)"
        }
    }
}

