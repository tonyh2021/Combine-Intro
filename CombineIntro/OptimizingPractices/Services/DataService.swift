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
                // Here we can use SessionManager.decode()
                guard let data = data else {
                    let error: NetworkError = .decodeDataNil
                    print("[Network Error]: \(error.localizedDescription)")
                    completion(nil, error.localizedDescription)
                    return
                }
                do {
                    let result = try JSONDecoder().decode([CoinModel].self, from: data)
                    DispatchQueue.main.async {
                        completion(result, nil)
                    }
                } catch let error {
                    print("[Network Error]: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(nil, error.localizedDescription)
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
                    promise(.failure(error))
                } else {
                    let result: Result<[CoinModel], NetworkError> = SessionManager.decode(data)
                    switch result {
                    case .success(let obj):
                        promise(.success(obj))
                    case .failure(let error):
                        print("[Network Error]: \(error.localizedDescription)")
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
