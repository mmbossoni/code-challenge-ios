//
//  Movie.swift
//  MovieList
//
//  Created by Marcelo on 01/08/19.
//  Copyright © 2019 Marcelo. All rights reserved.
//

import Foundation

struct MovieModel {
    var id: Int
    var posterPath: String?
    var backdropPath: String?
    var overview: String?
    var releaseDate: String?
    var title: String?
    var genres: [String]?
}
