//
//  ApiManager.swift
//  MovieBrowser
//
//  Created by Karol Wieczorek on 04/11/2022.
//

import Foundation
import UIKit

final class ApiManager {
    private enum Constants {
        static let apiKey: String = "2f114110ffe01902960893bcac96de55"
    }

    private let urlSession = URLSession.shared
    private let decoder = JSONDecoder()

    func makeRequest<T: Codable>(request: ApiRequest, completion: @escaping (Result<T, Error>) -> Void) {
        urlSession.dataTask(with: makeURLRequest(from: request)) { [weak self] data, _, error in
            guard let self = self else {
                completion(.failure(UnknownApiError()))
                return
            }

            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    completion(.success(try self.decoder.decode(T.self, from: data)))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(UnknownApiError()))
            }
        }.resume()
    }
    
    func makeImageRequest(request: ApiRequest, completion: @escaping (Result<UIImage, Error>) -> Void) {
        urlSession.dataTask(with: makeURLRequest(from: request)) { [weak self] data, _, error in
            guard self != nil else {
                completion(.failure(UnknownApiError()))
                return
            }

            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                let image = UIImage(data: data) ?? nil
                
                if image != nil {
                    completion(.success(image!))
                } else {
                    completion(.failure(UnknownApiError()))
                }
            } else {
                completion(.failure(UnknownApiError()))
            }
        }.resume()
    }

    private func makeURLRequest(from apiRequest: ApiRequest) -> URLRequest {
        URLRequest(url: apiRequest.baseURL
            .appending(path: apiRequest.endpoint)
            .appending(queryItems: [URLQueryItem(name: "api_key", value: Constants.apiKey)])
            .appending(queryItems: apiRequest.params)
        )
    }
}
