//
//  UpcomingMoviesInteractor.swift
//  MovieList
//
//  Created by Marcelo on 02/08/19.
//  Copyright © 2019 Marcelo. All rights reserved.
//

import Foundation

protocol UpcomingMoviesInteractorOutputProtocol: class {
    func didRetrieveMovies(movies: [MovieModel])
    func errorDidOccur(error: Error)
    func searchDidFinish(movies: [MovieModel])
}

protocol UpcomingMoviesInteractorInputProtocol {
    var presenter: UpcomingMoviesInteractorOutputProtocol? { get set }
    func loadNextUpcomingMoviesPage()
    func searchMovies(query: String)
}

class UpcomingMoviesInteractor: UpcomingMoviesInteractorInputProtocol {
    private var lastSuccessPage: Int = 0;
    private var movieService: MovieServiceProtocol
    weak var presenter: UpcomingMoviesInteractorOutputProtocol?
    
    init(withService service: MovieServiceProtocol) {
        self.movieService = service
    }
    
    func loadNextUpcomingMoviesPage() {
        self.movieService.loadNextUpcomingMovies() { result in
            switch result {
            case .success(let movies):
                self.presenter?.didRetrieveMovies(movies: movies)
            case .error(let error):
                self.presenter?.errorDidOccur(error: error)
            }
        }
    }
    
    func searchMovies(query: String) {
        self.movieService.searchMovies(query: query) { result in
            switch result {
            case .success(let movies):
                self.presenter?.searchDidFinish(movies: movies)
            case .error(let error):
                self.presenter?.errorDidOccur(error: error)
            }
        }
    }
}
