//
//  ComposingOperatorDemo.swift
//  CombineIntro
//
//  Created by Tony on 2023-04-01.
//

import Foundation
import Combine

class CustomizeOperatorViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 1
        let sample = [1, 3, 2, 1, 4, 2, 3, 2]
        // 2
        sample.publisher
        // 3
            .reduce([Int:Int](), { accum, value in
//                print("3: \(accum), \(value)")
                var next = accum
                if let current = next[value] {
                    next[value] = current + 1
                } else {
                    next[value] = 1
                }
                return next
            })
        // 4
            .map({ item in
//                print("4: \(item)")
                return item.sorted { element1, element2 in
                    element1.key < element2.key
                }
            })
        // 5
            .map({ item in
                var result = ""
                for (key, value) in item {
                    result = "\(result)\(key): \(value)\n"
                }
                return result
            })
            .sink { completion in
            } receiveValue: { result in
                print(result)
            }
            .store(in: &cancellables)
        
        sample.publisher
            .countOccurrences()
            .sink { completion in
            } receiveValue: { result in
                print(result)
            }
            .store(in: &cancellables)
    }
}

extension Publisher where Output == Int, Failure == Never {
    
    func countOccurrences() -> AnyPublisher<String, Never> {
        self.reduce([Int:Int](), { accum, value in
            var next = accum
            if let current = next[value] {
                next[value] = current + 1
            } else {
                next[value] = 1
            }
            return next
        })
        .map({ item in
            return item.sorted { element1, element2 in
                element1.key < element2.key
            }
        })
        .map({ item in
            var result = ""
            for (key, value) in item {
                result = "\(result)\(key): \(value)\n"
            }
            return result
        })
        .eraseToAnyPublisher()
    }
}
