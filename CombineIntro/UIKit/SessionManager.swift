//
//  SessionManager.swift
//  CombineIntro
//
//  Created by Tony on 2023-04-02.
//

import Foundation
import Combine

enum NetworkError: LocalizedError {
    case badServerResponse(_ url: URL, code: Int)
    case unknown
    
    var errorDescription: String? {
        var description: String?
        switch self {
        case .badServerResponse(let url, code: let code):
            description = "[😰] Bad response from URL: \(url), Status Code:[\(code)]"
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
    
    static let shared = SessionManager()
    
    private init() {
        self.configure = URLSessionConfiguration.default
        configure.httpAdditionalHeaders = ["User-Agent": "CombineIntro iOS 1.0.0"]
        self.session = URLSession(configuration: configure)
    }
    
// MARK: Using closure
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
    
    static func handleURLResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> (Data?, Error?) {
        if let error = error {
            return (nil, error)
        }
        guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
            if let url = response?.url, let code = (response as? HTTPURLResponse)?.statusCode {
                return (nil, NetworkError.badServerResponse(url, code: code))
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
