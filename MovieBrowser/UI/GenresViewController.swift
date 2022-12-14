//
//  ViewController.swift
//  MovieBrowser
//
//  Created by Karol Wieczorek on 04/11/2022.
//

import UIKit

final class GenresViewController: UIViewController {
    private enum Constants {
        static let cellId = "GenresCell"
        static let title = "Genres"
    }

    private let genresProvider: GenresProvider

    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView()

    private var genres = [Genre]()

    init(genresProvider: GenresProvider) {
        self.genresProvider = genresProvider

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareUI()
        self.getGenres()
    }

    private func prepareUI() {
        prepareRootView()
        prepareTableView()
        DispatchQueue.main.async {
            self.prepareActivityIndicator()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if tableView.indexPathForSelectedRow != nil {
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
        }
    }

    private func prepareRootView() {
        title = Constants.title
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
        tableView.register(GenreCell.self, forCellReuseIdentifier: Constants.cellId)
        
        tableView.rowHeight = 75
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
    }

    private func getGenres() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        self.genresProvider.getGenres { result in
            switch result {
            case let .success(genres):
                self.genres = genres
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case let .failure(error):
                print("Cannot get genres, reason: \(error)")
            }
        }
        
    }
}

extension GenresViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let moviesProvider = MoviesProvider(apiManager: ApiManager())
        self.navigationController?.pushViewController(MoviesViewController(genre: genres[indexPath.row], moviesProvider: moviesProvider), animated: true)
        
    }
}

extension GenresViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        genres.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as! GenreCell
  
        cell.genreLabel.text = genres[indexPath.row].name

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            if self.activityIndicator.isAnimating{
                self.activityIndicator.stopAnimating()
            }
        }
        
        cell.alpha = 0
        cell.setSelected(false, animated: false)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction) {
            cell.alpha = 1
        }
    }
}
