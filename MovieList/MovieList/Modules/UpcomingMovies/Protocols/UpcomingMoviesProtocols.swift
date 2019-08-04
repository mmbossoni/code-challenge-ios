//
//  Protocols.swift
//  MovieList
//
//  Created by Marcelo on 04/08/19.
//  Copyright © 2019 Marcelo. All rights reserved.
//

import UIKit

protocol UpcomingMoviesViewProtocol: class {
    var presenter: UpcomingMoviesPresenterProtocol? { get set }
    
    func showError(error: Error)
    func showLoading(show: Bool)
    func showMovies(movies: [MovieViewModel])
}

protocol UpcomingMoviesPresenterProtocol {
    var view: UpcomingMoviesViewProtocol? { get set }
    var interactor: UpcomingMoviesInteractorInputProtocol? { get set }
    var router: UpcomingMoviesRouterProtocol? { get set }
    
    func viewDidLoad()
    func userDidRequestMoreMovies()
    func userDidSelectMovie(movie: MovieViewModel)
    func userDidSearchMovies(query: String)
    func searchDidFinish()
}

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

protocol UpcomingMoviesConfiguratorProtocol {
    static func createUpcomingMoviesModule() -> UIViewController
}

protocol UpcomingMoviesRouterProtocol {
    func showMovieDetails(from view: UpcomingMoviesViewProtocol, for movieId: Int)
}


