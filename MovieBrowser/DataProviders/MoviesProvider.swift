//
//  MoviesProvider.swift
//  MovieBrowser
//
//  Created by Gonzalo Fuentes on 22/11/22.
//

import Foundation
import UIKit

final class MoviesProvider {
    private let apiManager: ApiManager
    private let imageCache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()

    init(apiManager: ApiManager) {
        self.apiManager = apiManager
    }

    func getMoviesOfGenre(genre_id: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        apiManager.makeRequest(request: ApiRequest(endpoint: "/discover/movie", params: [URLQueryItem(name: "with_genres", value: String(genre_id)), URLQueryItem(name: "language", value: "en-US")])) { (response: Result<MoviesResponse, Error>) in
            switch response {
            case let .success(response):
                completion(.success(response.results))
            case let .failure(error) :
                completion(.failure(error))
            }
        }
    }
    
    func getMovieRuntime(movie_id: Int, completion: @escaping (Result<Int, Error>) -> Void) {
        apiManager.makeRequest(request: ApiRequest(endpoint: "/movie/" + String(movie_id))) { (response: Result<Runtime, Error>) in
            switch response {
            case let .success(response):
                completion(.success(response.runtime))
            case let .failure(error) :
                completion(.failure(error))
            }
        }
    }
    
    
    
    func getMoviePoster(poster_path: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let image = imageCache.object(forKey: poster_path as NSString){
            completion(.success(image))
        }
        
        apiManager.makeImageRequest(request: ApiRequest(baseURL: URL(string: "https://image.tmdb.org/t/p/w500/")!, endpoint: poster_path)) { (response: Result<UIImage, Error>) in
            switch response {
            case let .success(response):
                self.imageCache.setObject(response, forKey: poster_path as NSString)
                completion(.success(response))
            case let .failure(error) :
                completion(.failure(error))
            }
        }
    }
}

private struct MoviesResponse: Codable {
    let results: [Movie]
}

private struct Runtime: Codable {
    let runtime: Int
}
