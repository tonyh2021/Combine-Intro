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

    private(set) var dataSourceV0: [CoinModel] = []
    private(set) var errorV0: String? = nil
    
    let dataSourceV2 = CurrentValueSubject<[CoinModel], Never>([CoinModel]())
    let errorV2 = CurrentValueSubject<String, Never>("")
    private var cancellables = Set<AnyCancellable>()
    
    private var dataService: DataServiceable
    
    init(dataService: DataServiceable = CoinService()) {
        self.dataService = dataService
        super.init()
        
    }
        
    func fetchCoinListV0(completion: @escaping () -> Void) {
        let completion: (_ coinList: [CoinModel]?, _ error: String?) -> Void = { [weak self] coinList,error in
            if let coinList = coinList {
                self?.dataSourceV0 = coinList
            }
            if let error = error {
                self?.errorV0 = error
            }
            completion()
        }
        
//        dataService.fetchDataV0(completion: completion)
        
        dataService.fetchDataV1(completion: completion)
    }
    
    func fetchCoinListV2() {
        dataService.fetchDataV2()
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.errorV2.send(error.localizedDescription)
                    self.dataSourceV2.send([])
                case .finished: return
                }
            } receiveValue: { [weak self] restult in
                guard let self = self else { return }
                self.dataSourceV2.send(restult)
            }
            .store(in: &cancellables)
    }
}
