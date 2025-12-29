//
//  NetworClient.swift
//  MovieQuiz
//
//  Created by Ilman on 24.11.2025.
//

import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result <Data, Error>) -> Void)
}

struct NetworkClient: NetworkRouting {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, respons, error in
            
            if let error = error {
                handler(.failure(error))
                return
            }
            
            if let respons = respons as? HTTPURLResponse, respons.statusCode < 200 || respons.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            guard let data = data else { return }
            handler(.success(data))
            
        }
        
        task.resume()
    }
}

