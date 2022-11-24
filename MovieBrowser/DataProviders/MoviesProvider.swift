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
    
    var movies = [Movie]()
    var total_pages = 1
    var error: Error? = nil
    var dispatchGroup = DispatchGroup()

    init(apiManager: ApiManager) {
        self.apiManager = apiManager
    }
    
    func getMoviesOfGenreWithPages(genre_id: Int, pages: Int, completion: @escaping (Result<MoviesResponse, Error>) -> Void) {
        
        
        for i in 1...pages {
            if i > total_pages {
                completion(.success(MoviesResponse(results: movies, total_pages: total_pages)))
            }
            
            self.dispatchGroup.enter()
            self.getMoviesOfGenre(genre_id: genre_id, page: i) { result in
                switch result {
                case let .success(tempMovies):
                    self.movies += tempMovies.results
                    self.total_pages = tempMovies.total_pages
                case let .failure(tempError):
                    print("Cannot get movies, reason: \(tempError)")
                    self.error = tempError
                }
                
                self.dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main, execute: {
            if self.movies.count > 0 {
                completion(.success(MoviesResponse(results: self.movies, total_pages: self.total_pages)))
            } else {
                if self.error != nil {
                    completion(.failure(self.error!))
                }
            }
        })
    }

    func getMoviesOfGenre(genre_id: Int, page: Int, completion: @escaping (Result<MoviesResponse, Error>) -> Void) {
        apiManager.makeRequest(request: ApiRequest(endpoint: "/discover/movie", params: [URLQueryItem(name: "with_genres", value: String(genre_id)), URLQueryItem(name: "page", value: String(page))])) { (response: Result<MoviesResponse, Error>) in
            
            switch response {
            case let .success(response):
                completion(.success(response))
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

struct MoviesResponse: Codable {
    let results: [Movie]
    let total_pages: Int
}

private struct Runtime: Codable {
    let runtime: Int
}
