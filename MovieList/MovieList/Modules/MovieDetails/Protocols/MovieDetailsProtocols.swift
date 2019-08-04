//
//  MovieDetailsProtocols.swift
//  MovieList
//
//  Created by Marcelo on 04/08/19.
//  Copyright © 2019 Marcelo. All rights reserved.
//

import UIKit

protocol MovieDetailsViewProtocol: class {
    var presenter: MovieDetailsPresenterProtocol? { get set }
    
    func showError(error: Error)
    func showLoading(show: Bool)
    func showMovieDetails(movie: MovieViewModel)
}

protocol MovieDetailsPresenterProtocol {
    var view: MovieDetailsViewProtocol? { get set }
    var interactor: MovieDetailsInteractorInputProtocol? { get set }
    var router: MovieDetailsRouterProtocol? { get set }
    var movieId: Int? { get set }
    
    func viewDidLoad()
}

protocol MovieDetailsInteractorOutputProtocol: class {
    func didRetrieveMovieDetails(movie: MovieViewModel)
    func errorDidOccur(error: Error)
}

protocol MovieDetailsInteractorInputProtocol {
    var presenter: MovieDetailsInteractorOutputProtocol? { get set }
    func loadMovieDetails(for movieId: Int)
}

protocol MovieDetailsConfiguratorProtocol {
    static func createMovieDetailsModule(forMovieId id: Int) -> UIViewController
}

protocol MovieDetailsRouterProtocol {
    func showMovieDetails(from view: UIViewController, for movieId: Int)
}
