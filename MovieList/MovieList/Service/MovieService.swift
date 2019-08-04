//
//  MovieService.swift
//  MovieList
//
//  Created by Marcelo on 01/08/19.
//  Copyright © 2019 Marcelo. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
}

protocol MovieServiceProtocol {
    func loadNextUpcomingMovies(completionHandler: ((Result<[MovieModel]>) -> Void)?)
    func getMovieDetails(movieId id: Int, completion completionHandler: ((Result<MovieModel>) -> Void)?)
    func searchMovies(query: String, completion completionHandler: ((Result<[MovieModel]>) -> Void)?)
}
