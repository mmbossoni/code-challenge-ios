//
//  MovieDetailsInteractor.swift
//  MovieList
//
//  Created by Marcelo on 03/08/19.
//  Copyright © 2019 Marcelo. All rights reserved.
//

import Foundation

protocol MovieDetailsInteractorOutputProtocol: class {
    func didRetrieveMovieDetails(movie: MovieViewModel)
    func errorDidOccur(error: Error)
}

protocol MovieDetailsInteractorInputProtocol {
    var presenter: MovieDetailsInteractorOutputProtocol? { get set }
    func loadMovieDetails(for movieId: Int)
}

class MovieDetailsInteractor: MovieDetailsInteractorInputProtocol {
    private var movieService: MovieServiceProtocol
    weak var presenter: MovieDetailsInteractorOutputProtocol?
    
    init(withService service: MovieServiceProtocol) {
        self.movieService = service
    }
    
    func loadMovieDetails(for movieId: Int) {
        self.movieService.getMovieDetails(movieId: movieId) { result in
            switch result {
            case .success(let movie):
                self.presenter?.didRetrieveMovieDetails(movie: MovieViewModel(with: movie))
            case .error(let error):
                self.presenter?.errorDidOccur(error: error)
            }
        }
    }
}
