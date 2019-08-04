//
//  UpcomingMoviesRouter.swift
//  MovieList
//
//  Created by Marcelo on 02/08/19.
//  Copyright © 2019 Marcelo. All rights reserved.
//

import UIKit

class UpcomingMoviesRouter: UpcomingMoviesRouterProtocol, UpcomingMoviesConfiguratorProtocol {
    static var storyboard = UIStoryboard(name: "UpcomingMovies", bundle: Bundle.main)
    static let screenId = "UpcomingMoviesNavigation"
    
    static func createUpcomingMoviesModule() -> UIViewController {
        let navController = storyboard.instantiateViewController(withIdentifier: screenId)
        if let view = navController.children.first as? UpcomingMoviesViewController {
            let presenter = UpcomingMoviesPresenter()
            let interactor = UpcomingMoviesInteractor(withService: TMDBMovieService())
            let router = UpcomingMoviesRouter()
            
            view.presenter = presenter
            presenter.view = view
            presenter.router = router
            presenter.interactor = interactor
            interactor.presenter = presenter

            return navController
        }
        return UIViewController()

    }
    
    func showMovieDetails(from view: UpcomingMoviesViewProtocol, for movieId: Int) {
        if let view = view as? UIViewController {
            MovieDetailsRouter().showMovieDetails(from: view, for: movieId)
        }
    }
}
