//
//  UpcomingMoviesPresenter.swift
//  MovieList
//
//  Created by Marcelo on 02/08/19.
//  Copyright © 2019 Marcelo. All rights reserved.
//

import Foundation

class UpcomingMoviesPresenter: UpcomingMoviesPresenterProtocol, UpcomingMoviesInteractorOutputProtocol {
    
    private var loadingCount = 0
    private var loadingSyncLock = NSLock()
    private var movieIdMap: [MovieViewModel:Int] = [:]
    private var movies: [MovieViewModel] = []
    
    // MARK: UpcomingMoviesPresenterProtocol
    weak var view: UpcomingMoviesViewProtocol?
    
    var interactor: UpcomingMoviesInteractorInputProtocol?
    
    var router: UpcomingMoviesRouterProtocol?
    
    func viewDidLoad() {
        updateLoadingTaskCount(by: 1)
        interactor?.loadNextUpcomingMoviesPage()
    }
    
    func userDidRequestMoreMovies() {
        updateLoadingTaskCount(by: 1)
        view?.showLoading(show: true)
        interactor?.loadNextUpcomingMoviesPage()
    }
    
    
    func userDidSelectMovie(movie: MovieViewModel) {
        if let view = view {
            if let movieId = self.movieIdMap[movie] {
                router?.showMovieDetails(from: view, for: movieId)
            }
        }
    }
    
    func userDidSearchMovies(query: String) {
        if query.trimmingCharacters(in: .whitespaces).isEmpty {
           view?.showMovies(movies: self.movies)
        } else {
            updateLoadingTaskCount(by: 1)
            interactor?.searchMovies(query: query)
        }
    }
    
    func searchDidFinish() {
        view?.showMovies(movies: self.movies)
        updateLoadingTaskCount(by: -1)
    }
    
    // MARK: UpcomingMoviesInteractorOutputProtocol
    func didRetrieveMovies(movies: [MovieModel]) {
        updateLoadingTaskCount(by: -1)
        for movie in movies {
            let vm = MovieViewModel(with: movie)
            self.movieIdMap[vm] = movie.id
            self.movies.append(vm)
        }

        view?.showMovies(movies: self.movies)
    }
    
    func searchDidFinish(movies: [MovieModel]) {
        let movieViewModels = movies.map { movie -> MovieViewModel in
            let vm = MovieViewModel(with: movie)
            self.movieIdMap[vm] = movie.id
            return vm
        }
        
        view?.showMovies(movies: movieViewModels)
    }
    
    func errorDidOccur(error: Error) {
        updateLoadingTaskCount(by: -1)
        view?.showError(error: error)
    }
    
    
    // MARK: Private methods
    private func updateLoadingTaskCount(by adding: Int) {
        var showLoading: Bool?;
        loadingSyncLock.lock()
        loadingCount += adding
        if (loadingCount == 1) {
            showLoading = true
        } else if (loadingCount == 0) {
            showLoading = false
        }
        loadingSyncLock.unlock()
        if let showLoading = showLoading {
            view?.showLoading(show: showLoading)
        }
    }
}
