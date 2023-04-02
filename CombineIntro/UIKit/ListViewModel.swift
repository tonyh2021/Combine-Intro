//
//  ListViewModel.swift
//  CombineIntro
//
//  Created by Tony on 2023-04-01.
//

import UIKit
import Combine

class BaseViewModel {
}


final class ListViewModel: BaseViewModel {

    private(set) var dataSource: [CoinModel] = []
    
    private(set) var error: String? = nil
    
    private var dataService: DataServiceable
    
    init(dataService: DataServiceable = CoinService()) {
        self.dataService = dataService
        super.init()
        
    }
        
    func fetchCoinList(completion: @escaping () -> Void) {
        dataService.fetchData { [weak self] coinList, error in
            if let coinList = coinList {
                self?.dataSource = coinList
            }
            if let error = error {
                self?.error = error
            }
            completion()
        }
    }
}
