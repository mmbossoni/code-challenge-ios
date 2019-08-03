//
//  MovieDetailsViewController.swift
//  MovieList
//
//  Created by Marcelo on 03/08/19.
//  Copyright © 2019 Marcelo. All rights reserved.
//

import UIKit
import Kingfisher

protocol MovieDetailsViewProtocol: class {
    var presenter: MovieDetailsPresenterProtocol? { get set }
    
    func showError(error: Error)
    func showLoading(show: Bool)
    func showMovieDetails(movie: MovieViewModel)
}

class MovieDetailsViewController: UIViewController, MovieDetailsViewProtocol {
    var presenter: MovieDetailsPresenterProtocol?
    private var movie: MovieViewModel?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        presenter?.viewDidLoad()
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if let movie = self.movie {
            showMovieDetails(movie: movie, forSize: size)
        }
    }
    
    func showMovieDetails(movie: MovieViewModel) {
        self.movie = movie;
        showMovieDetails(movie: movie, forSize: view.bounds.size)
    }
    
    func showMovieDetails(movie: MovieViewModel, forSize size: CGSize) {
        titleLabel.text = movie.title
        var backgroundImage: String?
        var imageViewImage: String?
        if size.width < size.height {
            backgroundImage = movie.posterPath
            imageViewImage = movie.backdropPath
        } else {
            backgroundImage = movie.backdropPath
            imageViewImage = movie.posterPath
        }
        
        if let imageViewImage = imageViewImage, let imageViewImageUrl = URL(string: imageViewImage) {
            imageView.kf.setImage(with: imageViewImageUrl)
        }
        
        if let backgroundImage = backgroundImage, let backgroundImageUrl = URL(string: backgroundImage) {
            KingfisherManager.shared.retrieveImage(with: backgroundImageUrl) {[weak self] result in
                if case .success(let image) = result {
                    self?.view.backgroundColor = UIColor(patternImage: UIImage.resize(image: image.image, targetSize: size))
                }
            }
        }
 
        releaseDateLabel.text = movie.releaseDate
        genresLabel.text = movie.genres
        overviewLabel.text = movie.overview
    }
    
    
    
}
