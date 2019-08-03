//
//  MovieDetailsRouter.swift
//  MovieList
//
//  Created by Marcelo on 03/08/19.
//  Copyright © 2019 Marcelo. All rights reserved.
//

import UIKit

protocol MovieDetailsConfiguratorProtocol {
    static func createMovieDetailsModule(forMovieId id: Int) -> UIViewController
}

protocol MovieDetailsRouterProtocol {
    func showMovieDetails(from view: UIViewController, for movieId: Int)
}

class MovieDetailsRouter: MovieDetailsRouterProtocol, MovieDetailsConfiguratorProtocol {
    static var storyboard = UIStoryboard(name: "MovieDetails", bundle: Bundle.main)
    static let screenId = "MovieDetailsViewController"
    
    static func createMovieDetailsModule(forMovieId id: Int) -> UIViewController {
        let view = storyboard.instantiateViewController(withIdentifier: screenId)
        let presenter = MovieDetailsPresenter()
        let interactor = MovieDetailsInteractor(withService: TMDBMovieService())
        let router = MovieDetailsRouter()
        
        if let view = view as? MovieDetailsViewProtocol {
            view.presenter = presenter
            presenter.view = view
        }
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        presenter.movieId = id
        
        return view
    }
    
    func showMovieDetails(from view: UIViewController, for movieId: Int) {
        let details = MovieDetailsRouter.createMovieDetailsModule(forMovieId: movieId)
        view.navigationController?.pushViewController(details, animated: true)
    }
}
