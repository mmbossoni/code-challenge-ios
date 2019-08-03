//
//  MovieViewModel.swift
//  MovieList
//
//  Created by Marcelo on 02/08/19.
//  Copyright © 2019 Marcelo. All rights reserved.
//

import Foundation
struct MovieViewModel: Hashable {
    var posterPath: String?
    var backdropPath: String?
    var overview: String?
    var releaseDate: String?
    var title: String?
    var genres: String?
    
    init(with movie: MovieModel) {
        posterPath = movie.posterPath
        backdropPath = movie.backdropPath
        overview = movie.overview
        releaseDate = movie.releaseDate
        title = movie.title
        genres = movie.genres?.joined(separator: ", ")
    }
}
