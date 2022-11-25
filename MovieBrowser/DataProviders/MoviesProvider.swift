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
    
    var moviesDict = [Int: [Movie]]()
    var totalMovies = [Movie]()
    var total_pages: Int? = nil
    var error: Error? = nil
    var dispatchGroup = DispatchGroup()

    init(apiManager: ApiManager) {
        self.apiManager = apiManager
    }
    
    // MARK: Get movies of a genre until page number n
    func getMoviesOfGenreWithPages(genre_id: Int, pages: Int, completion: @escaping (Result<MoviesResponse, Error>) -> Void) {
        for i in 1...pages {
            if self.total_pages != nil && i > self.total_pages! {
                break
            }
            
            self.dispatchGroup.enter()
            
            self.getMoviesOfGenre(genre_id: genre_id, page: i) { result in
                switch result {
                case let .success(tempMovies):
                    self.moviesDict[i] = tempMovies.results
                    print(tempMovies.total_pages)
                    if self.total_pages == nil {
                        self.total_pages = tempMovies.total_pages
                    }
                case let .failure(tempError):
                    print("Cannot get movies, reason: \(tempError)")
                    self.error = tempError
                }
                
                self.dispatchGroup.leave()
            }
        }
        
        // Wait for all pages to process before sorting and returning the content
        dispatchGroup.notify(queue: .main, execute: {
            if self.moviesDict.count > 0 {
                // print(self.moviesDict)
                let sortedMovies = self.moviesDict.sorted(by: {$0.key < $1.key})
                                
                for (_, moviesInPage) in sortedMovies {
                    self.totalMovies.append(contentsOf: moviesInPage)
                }
                
                completion(.success(MoviesResponse(results: self.totalMovies, total_pages: self.total_pages!)))
            } else {
                if self.error != nil {
                    completion(.failure(self.error!))
                }
            }
        })
    }
    
    
    // MARK: Get movies of page number n
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
    
    // MARK: Get movie duration
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
    
    // MARK: Get movie poster from cache, if not found make a request
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
