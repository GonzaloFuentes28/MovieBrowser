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
    
    private var pagesLoaded: Int = 1
    private var total_pages: Int = 1
    
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView()
    private let searchController = UISearchController()
    private let searchBar: UISearchBar
    
    private var allMovies = [Movie]()
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
        
        self.prepareUI()
        self.getMovies()
    }
    
    private func prepareUI() {
        prepareRootView()
        prepareTableView()
        prepareSearchBar()
        prepareActivityIndicator()
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
        tableView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
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
        
        self.moviesProvider.getMoviesOfGenreWithPages(genre_id: genre.id, pages: 2) { result in
            switch result {
            case let .success(movies):
                self.movies = movies.results
                self.total_pages = movies.total_pages
                
                self.pagesLoaded = 2
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.scrollToTop(animated: true)
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
        // MARK: Load next page if user reaching the end
        DispatchQueue.main.async {
            if self.searchController.isActive == false && self.searchBar.text == "" {
                if (indexPath.row == self.movies.count-1) {
                    self.moviesProvider.getMoviesOfGenre(genre_id: self.genre.id, page: self.pagesLoaded+1) { result in
                        switch result {
                        case let .success(movies):
                            self.pagesLoaded += 1
                            self.movies += movies.results
                            self.total_pages = movies.total_pages
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
                        case let .failure(error):
                            print("Cannot get movies, reason: \(error)")
                        }
                    }
                }
            }
        }
        
        // MARK: Load data in cell
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as! MovieCell
        cell.titleLabel.text = movies[indexPath.row].title
        cell.yearLabel.text = movies[indexPath.row].getYear()
        cell.posterImageView.image = UIImage(named: "PosterPlaceholder")
        cell.descriptionTextView.text = movies[indexPath.row].overview
        cell.ratingLabel.text = String(movies[indexPath.row].vote_average!)
        
        // MARK: Make API call to get runtime
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
        
        // MARK: Make API call to get poster
        if movies[indexPath.row].poster_path != nil{
            self.moviesProvider.getMoviePoster(poster_path: movies[indexPath.row].poster_path!) { result in
                switch result {
                case let .success(image):
                    DispatchQueue.main.async {
                        UIView.transition(with: cell.posterImageView, duration: 0.3, options: [.transitionCrossDissolve], animations: {cell.posterImageView.image = image})
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
    
    // MARK: Cell animations
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            if self.activityIndicator.isAnimating{
                self.activityIndicator.stopAnimating()
            }
        }
        
        cell.alpha = 0
        cell.setSelected(false, animated: false)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction) {
            cell.alpha = 1
        }
    }
}

// MARK: Table view delegate
extension MoviesViewController: UITableViewDelegate {
    
}

// MARK: Search bar delegate
extension MoviesViewController: UISearchBarDelegate {
    
    // MARK: Search movies and sort them by rating
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.movies = []
            self.tableView.reloadData()
            self.activityIndicator.startAnimating()
            
            let searchText = searchBar.text!
            
            self.moviesProvider.getMoviesOfGenreWithPages(genre_id: self.genre.id, pages: 10) { result in
                switch result {
                case let .success(movies):
                    self.movies = Array(Set(movies.results.filter({ movie in
                        return movie.title!.contains(searchText)
                    }))).sorted(by: { movie1, movie2 in
                        return movie1.vote_average! > movie2.vote_average!
                    })
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.tableView.scrollToTop(animated: true)
                    }
                case let .failure(error):
                    print("Cannot get movies, reason: \(error)")
                }
            }
        }
    }
    
    // MARK: Reload default movies
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.getMovies()
    }
}
