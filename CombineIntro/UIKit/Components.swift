//
//  Components.swift
//  CombineIntro
//
//  Created by Tony on 2023-04-01.
//

import UIKit

class CoinCell: UITableViewCell {
    
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
    
    var coinModel: CoinModel? {
        didSet {
            textLabel?.text = coinModel?.name
        }
    }
}

