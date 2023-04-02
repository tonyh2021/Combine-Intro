//
//  DataService.swift
//  CombineIntro
//
//  Created by Tony on 2023-04-01.
//

import Foundation
import Combine

protocol DataServiceable {
    
    func fetchDataV0(completion: @escaping ((_ coinList: [CoinModel]?, _ error: String?) -> Void))
    
    func fetchDataV1(completion: @escaping ((_ coinList: [CoinModel]?, _ error: String?) -> Void))
    
    func fetchDataV2() -> AnyPublisher<[CoinModel], Error>
}

struct CoinService {
    
    var subscription: AnyCancellable?
    
    let coinListUrl = "/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
}

extension CoinService: DataServiceable {
    
    func fetchDataV0(completion: @escaping ((_ coinList: [CoinModel]?, _ error: String?) -> Void)) {
        SessionManager.shared.fetch(coinListUrl) { data, error in
            if let error = error {
                print("[Network Error]: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil, error.localizedDescription)
                }
            } else {
                let (data, error) = SessionManager.decode(data, [CoinModel].self)
                DispatchQueue.main.async {
                    if let error = error {
                        print("[Network Error]: \(error.localizedDescription)")
                        completion(nil, error.localizedDescription)
                    } else {
                        completion(data, nil)
                    }
                }
            }
        }
    }
    
    func fetchDataV1(completion: @escaping ((_ coinList: [CoinModel]?, _ error: String?) -> Void)) {
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
    
    func fetchDataV2() -> AnyPublisher<[CoinModel], Error> {
        Future { promise in
            SessionManager.shared.fetch(coinListUrl) { data, error in
                if let error = error {
                    print("[Network Error]: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        promise(.failure(error))
                    }
                } else {
                    let (data, error) = SessionManager.decode(data, [CoinModel].self)
                    DispatchQueue.main.async {
                        if let error = error {
                            print("[Network Error]: \(error.localizedDescription)")
                            promise(.failure(error))
                        } else {
                            promise(.success(data ?? []))
                        }
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
