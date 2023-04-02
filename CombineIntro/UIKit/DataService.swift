//
//  DataService.swift
//  CombineIntro
//
//  Created by Tony on 2023-04-01.
//

import Foundation

protocol DataServiceable {
    
    func fetchData(completion: @escaping ((_ coinList: [CoinModel]?, _ error: String?) -> Void))
}

enum NetworkError: LocalizedError {
    case badServerResponse(url: URL)
    case unknown
    
    var errorDescription: String? {
        var description: String?
        switch self {
        case .badServerResponse(url: let url):
            description = "[😰] Bad response from URL: \(url)"
        case .unknown:
            description = "[⚠️] Unknown error occured."
        }
        return description
    }
}

struct SessionManager {
    
    static private var debug = true
    
    let baseUrl = "https://api.coingecko.com"
    
    let configure: URLSessionConfiguration
    let session: URLSession
    
    typealias CompletionHandler<T: Codable> = (Result<T, Error>) -> Void
    
    func fetchDataTask<T: Codable>(_ url: String, _ type: T.Type, completionHandler: @escaping CompletionHandler<T>) -> URLSessionDataTask {
        let URL = URL(string: baseUrl.appending(url))!
        return session.dataTask(with: URL) { data, response, error in
            let (data, error) = SessionManager.handleURLResponse(data, response, error)
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            if let data = data {
                let (obj, error) = SessionManager.decode(data, type)
                if let error = error {
                    completionHandler(.failure(error))
                } else if let obj = obj {
                    completionHandler(.success(obj))
                }
                return
            }
            completionHandler(.failure(NetworkError.unknown))
        }
    }
    
    func fetch<T: Codable>(_ url: String, _ type: T.Type, completionHandler: @escaping CompletionHandler<T>) {
        let _ = fetchDataTask(url, type, completionHandler: completionHandler).resume()
    }
    
    static let shared = SessionManager()
    
    private init() {
        self.configure = URLSessionConfiguration.default
        configure.httpAdditionalHeaders = ["User-Agent": "CombineIntro iOS 1.0.0"]
        self.session = URLSession(configuration: configure)
    }
    
    static func handleURLResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> (Data?, Error?) {
        if let error = error {
            return (nil, error)
        }
        guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
            if let url = response?.url {
                return (nil, NetworkError.badServerResponse(url: url))
            } else {
                return (nil, NetworkError.unknown)
            }
        }
        if debug {
            print("URL: \(String(describing: response.url))")
            print("StatusCode: \(response.statusCode)")
            print("Data Length: \(data?.count ?? 0)")
//            do {
//                let json = try JSONSerialization.jsonObject(with: output.data, options: [])
//                print("Data: \(json)")
//            } catch let error {
//                print("Failed to print: \(error.localizedDescription)")
//            }
        }
        return (data, nil)
    }
    
    static func decode<T: Codable>(_ data: Data, _ type: T.Type) -> (T?, Error?) {
        do {
            let obj = try JSONDecoder().decode(type, from: data)
            return (obj, nil)
        } catch let error {
            return (nil, error)
        }
    }
}

final class CoinService: DataServiceable {
    
    let coinListUrl = "/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
    
    func fetchData(completion: @escaping ((_ coinList: [CoinModel]?, _ error: String?) -> Void)) {
        SessionManager.shared.fetch(coinListUrl, [CoinModel].self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let modelList):
                    completion(modelList, nil)
                case .failure(let error):
                    print("Network Error: \(error.localizedDescription)")
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
}
