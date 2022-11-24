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
    private let searchController = UISearchController()
    private let searchBar: UISearchBar
    
    private var movies = [Movie]()

    init(genre: Genre, moviesProvider: MoviesProvider) {
        self.moviesProvider = moviesProvider
        self.genre = genre
        self.searchBar = searchController.searchBar
        
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("View did load")
        
        self.prepareUI()
        self.getMovies()
    }
    
    private func prepareUI() {
        prepareRootView()
        prepareTableView()
        prepareSearchBar()
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
        tableView.rowHeight = 215
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "tableBackground")
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
    
    private func prepareSearchBar(){
        view.addSubview(searchBar)
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Start typing to search " + genre.name.lowercased() + " movies"
        searchBar.isTranslucent = false
        searchBar.returnKeyType = .search
        searchBar.enablesReturnKeyAutomatically = true
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
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            case let .failure(error):
                print("Cannot get movies, reason: \(error)")
            }
        }
        
    }
}

// MARK: Table view data source
extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as! MovieCell
        cell.titleLabel.text = movies[indexPath.row].title
        cell.yearLabel.text = movies[indexPath.row].getYear()
        cell.posterImageView.image = UIImage(named: "PosterPlaceholder")
        cell.descriptionTextView.text = movies[indexPath.row].overview
        cell.ratingLabel.text = String(movies[indexPath.row].vote_average!)
        
        self.moviesProvider.getMovieRuntime(movie_id: movies[indexPath.row].id!) { result in
            switch result {
            case let .success(runtime):
                DispatchQueue.main.async {
                    cell.durationLabel.text = String(runtime.convertToMovieLength())
                }
            case let .failure(error):
                print(" Cannot get runtime, reason: \(error)")
            }
        }
        
        if movies[indexPath.row].poster_path != nil{
            self.moviesProvider.getMoviePoster(poster_path: movies[indexPath.row].poster_path!) { result in
                switch result {
                case let .success(image):
                    DispatchQueue.main.async {
                        UIView.transition(with: cell.posterImageView, duration: 0.5, options: [.transitionCrossDissolve], animations: {cell.posterImageView.image = image})
                    }
                case let .failure(error):
                    print(" Cannot get poster image, reason: \(error)")
                }
                
            }

        }
        
        cell.clipsToBounds = false
        cell.contentView.clipsToBounds = false
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.setSelected(false, animated: false)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .allowUserInteraction) {
            cell.alpha = 1
        }
    }
}

// MARK: Table view delegate
extension MoviesViewController: UITableViewDelegate {
    
}

// MARK: Search bar delegate
extension MoviesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.movies = self.movies.filter({ movie in
            return movie.title!.contains(searchText)
        })
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.getMovies()
    }
    
    
}
