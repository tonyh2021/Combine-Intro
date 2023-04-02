//
//  DataService.swift
//  CombineIntro
//
//  Created by Tony on 2023-04-01.
//

import Foundation
import Combine

protocol DataServiceable {
    
    func fetchData(completion: @escaping ((_ coinList: [CoinModel]?, _ error: String?) -> Void))
}

final class CoinService {
    
    var subscription: AnyCancellable?
    
    let coinListUrl = "/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
}

extension CoinService: DataServiceable {
    
    func fetchData(completion: @escaping ((_ coinList: [CoinModel]?, _ error: String?) -> Void)) {
        SessionManager.shared.fetch(coinListUrl, [CoinModel].self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let modelList):
                    completion(modelList, nil)
                case .failure(let error):
                    print("[Network Error]: \(error.localizedDescription)")
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
}
