//
//  MoviesViewController.swift
//  MovieBrowser
//
//  Created by Karol Wieczorek on 04/11/2022.
//

import UIKit

final class MoviesViewController: UIViewController {
    private enum Constants {
        static let cellId = "MoviesCell"
    }
    
    private let moviesProvider: MoviesProvider
    private let genre: Genre
    
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView()

    private var movies = [Movie]()

    init(genre: Genre, moviesProvider: MoviesProvider) {
        self.moviesProvider = moviesProvider
        self.genre = genre
        
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareUI()
        self.getMovies()
    }
    
    
    private func prepareUI() {
        prepareRootView()
        prepareTableView()
        DispatchQueue.main.async {
            self.prepareActivityIndicator()
        }
    }

    private func prepareRootView() {
        title = genre.name
    }

    private func prepareTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: Constants.cellId)
        tableView.rowHeight = 200
        tableView.separatorStyle = .none
    }

    private func prepareActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.hidesWhenStopped = true
    }

    private func getMovies() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        self.moviesProvider.getMoviesOfGenre(genre_id: genre.id) { result in
            switch result {
            case let .success(movies):
                self.movies = movies
                DispatchQueue.main.async {
                    print("Preparing to reload data")
                    self.tableView.reloadData()
                    print("Preparing to stop animating")
                    self.activityIndicator.stopAnimating()
                }
            case let .failure(error):
                print("Cannot get movies, reason: \(error)")
            }
        }
        
    }
}

extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as! MovieCell
        cell.titleLabel.text = movies[indexPath.row].title
        
        if movies[indexPath.row].poster_path != nil{
            print("Getting image for movie " + movies[indexPath.row].title! + " with URL " + "https://image.tmdb.org/t/p/w500" + movies[indexPath.row].poster_path!)
            
            self.moviesProvider.getMoviePoster(poster_path: movies[indexPath.row].poster_path!, completion: { result in
                switch result {
                case let .success(image):
                    DispatchQueue.main.async {
                        cell.posterImageView.image = image
                    }
                case let .failure(error):
                    print(" Cannot get poster image, reason: \(error)")
                }
                
            })

        }
                
        return cell
    }
    
    
}

extension MoviesViewController: UITableViewDelegate {
    
}
