//
//  MovieDetailsPresenter.swift
//  MovieList
//
//  Created by Marcelo on 03/08/19.
//  Copyright © 2019 Marcelo. All rights reserved.
//

import Foundation

class MovieDetailsPresenter: MovieDetailsPresenterProtocol, MovieDetailsInteractorOutputProtocol {
    
    // MARK: MovieDetailsPresenterProtocol
    weak var view: MovieDetailsViewProtocol?
    
    var interactor: MovieDetailsInteractorInputProtocol?
    
    var router: MovieDetailsRouterProtocol?
    
    var movieId: Int?
    
    func viewDidLoad() {
        view?.showLoading(show: true)
        if let movieId = movieId {
            interactor?.loadMovieDetails(for: movieId)
        }
    }
    
    // MARK: MovieDetailsInteractorOutputProtocol
    func didRetrieveMovieDetails(movie: MovieViewModel) {
        view?.showLoading(show: false)
        view?.showMovieDetails(movie: movie)
    }
    
    func errorDidOccur(error: Error) {
        view?.showLoading(show: false)
        view?.showError(error: error)
    }
}
