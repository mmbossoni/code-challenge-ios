//
//  UpcomingMoviesViewController.swift
//  MovieList
//
//  Created by Marcelo on 01/08/19.
//  Copyright © 2019 Marcelo. All rights reserved.
//

import UIKit
import Kingfisher

class UpcomingMoviesViewController: UICollectionViewController, UpcomingMoviesViewProtocol {
    private var movies: [MovieViewModel] = []
    private var searchController: UISearchController!
    private var search: Debouncer!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var presenter: UpcomingMoviesPresenterProtocol?
    
    override func viewDidLoad() {
        collectionView.prefetchDataSource = self
        collectionView?.contentInsetAdjustmentBehavior = .always
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Movies"
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        search = Debouncer(delay: 0.5, callback: {
            self.performSearch()
        })
        
        presenter?.viewDidLoad()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionViewLayout.invalidateLayout()
    }
    
    func showError(error: Error) {
        
    }
    
    func showLoading(show: Bool) {
        activityIndicator.isHidden = !show
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func showMovies(movies: [MovieViewModel]) {
        self.movies = movies
        self.collectionView.reloadData()
    }
    
    private func performSearch() {
        if let query = searchController.searchBar.text {
            presenter?.userDidSearchMovies(query: query)
        }
    }
}

// MARK: DataSource
extension UpcomingMoviesViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath)
        if let movieCell = cell as? MovieCell {
            let movie = self.movies[indexPath.row]
            movieCell.titleLabel.text = movie.title
            movieCell.overviewLabel.text = movie.overview
            movieCell.genresLabel.text = movie.genres
            movieCell.releaseDateLabel.text = movie.releaseDate
            if let posterPath = movie.posterPath, let url = URL(string: posterPath) {
                movieCell.coverImage.kf.setImage(with: url)
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.userDidSelectMovie(movie: movies[indexPath.row])
    }
}


// MARK: Pre-loading
extension UpcomingMoviesViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if let row = indexPaths.max()?.row, row > self.movies.count - 5 {
            presenter?.userDidRequestMoreMovies()
        }
    }
}

// MARK: Cell Sizing
extension UpcomingMoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = collectionView.bounds.width - collectionView.safeAreaInsets.left - collectionView.safeAreaInsets.right - 16
        if collectionView.bounds.width > collectionView.bounds.height {
            width = width / 2
        }
        return CGSize(width: width, height: 136)
    }
}

// MARK: Search
extension UpcomingMoviesViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        self.search.call()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.presenter?.searchDidFinish()
    }
}
