//
//  TmdbMovieList.swift
//  MovieList
//
//  Created by Marcelo on 01/08/19.
//  Copyright © 2019 Marcelo. All rights reserved.
//

import Foundation
import Alamofire

// MARK: Internal decodables
fileprivate struct TmdbMovie: Decodable {
    var id: Int
    var poster_path: String?
    var backdrop_path: String?
    var overview: String?
    var release_date: String?
    var title: String?
    var genres: [Genre]?
    var genre_ids: [Int]?
}

fileprivate struct TmdbMovieList: Decodable {
    var results: [TmdbMovie]?
    var page: Int?
    var total_pages: Int?
}

fileprivate struct GenreList: Decodable {
    var genres: [Genre]?
}

fileprivate struct Genre: Decodable {
    var id: Int?
    var name: String?
}

// MARK: Internal constants
fileprivate let TMDB_API_KEY = "1f54bd990f1cdfb230adb312546d765d"
fileprivate let TMDB_API_HOST = "https://api.themoviedb.org/3"
fileprivate let TMDB_UPCOMING_MOVIES = TMDB_API_HOST + "/movie/upcoming"
fileprivate let TMDB_GENRES = TMDB_API_HOST + "/genre/movie/list"
fileprivate let TMDB_SEARCH_MOVIES = TMDB_API_HOST + "/search/movie"

// MARK: Implementation
class TMDBMovieService: MovieServiceProtocol {
    private var lastLoadedPage = 0
    private var lastRequestedPage = 0
    private var maxPages = 0
    private var serialQueue = DispatchQueue(label: "TMDB Service", qos: .background)
    private var genreCache: [Int:String] = [:]
    
    func loadNextUpcomingMovies(completionHandler: ((Result<[MovieModel]>) -> Void)?) {
        serialQueue.async {
            if self.genreCache.isEmpty {
                self.loadGenres(completion: { result in
                    switch (result) {
                    case .success(_):
                        self.loadNextUpcomingMovies(completionHandler: completionHandler)
                    case .error(let error):
                        completionHandler?(.error(error))
                    }
                })
                return
            }
            
            if self.maxPages > 0 && self.lastRequestedPage >= self.maxPages {
                DispatchQueue.main.async {
                    completionHandler?(.success([]))
                }
                return
            }
            
            let queryParams = ["api_key": TMDB_API_KEY,
                               "page": String(self.lastRequestedPage + 1)]
            self.lastRequestedPage += 1
            AF.request(TMDB_UPCOMING_MOVIES, method: .get, parameters: queryParams)
                .responseDecodable(of: TmdbMovieList.self) { (response: DataResponse<TmdbMovieList>) in
                    if let error = response.error {
                        completionHandler?(.error(error))
                    } else {
                        switch(response.result) {
                        case .success(let movieList):
                            if self.maxPages == 0, let totalPages = movieList.total_pages {
                                self.maxPages = totalPages
                            }
                            self.lastLoadedPage += 1
                            let movies: [TmdbMovie] = movieList.results ?? []
                            let movieModels = movies.map({ movie -> MovieModel in
                                // Poster path and genre id resolution
                                var model = MovieModel(withMovie: movie)
                                if let posterPath = movie.poster_path {
                                    model.posterPath = "https://image.tmdb.org/t/p/w342" + posterPath
                                }
                                if let genreIds = movie.genre_ids {
                                    model.genres = genreIds.compactMap({ genreId in
                                        return self.genreCache[genreId]
                                    })
                                }
                                return model
                            })
                            completionHandler?(.success(movieModels))
                        case .failure(let error):
                            completionHandler?(.error(error))
                        }
                    }
            }
        }
    }
    
    func getMovieDetails(movieId id: Int, completion completionHandler: ((Result<MovieModel>) -> Void)?) {
        let movieDetailUrl = TMDB_API_HOST + "/movie/\(id)"
        let queryParams = ["api_key": TMDB_API_KEY]
        AF.request(movieDetailUrl, method: .get, parameters: queryParams)
            .responseDecodable(of: TmdbMovie.self) { (response: DataResponse<TmdbMovie>) in
                if let error = response.error {
                    completionHandler?(.error(error))
                } else {
                    switch(response.result) {
                    case .success(let movie):
                        
                        var model = MovieModel(withMovie: movie)
                        
                        // Poster path resolution. For details get full size poster
                        if let posterPath = movie.poster_path {
                            model.posterPath = "https://image.tmdb.org/t/p/original" + posterPath
                        }
                        if let genres = movie.genres {
                            model.genres = genres.map({ genre in genre.name ?? "" })
                        }
                        completionHandler?(.success(model))
                    case .failure(let error):
                        completionHandler?(.error(error))
                    }
                }
        }
    }
    
    func searchMovies(query: String, completion completionHandler: ((Result<[MovieModel]>) -> Void)?) {
        let queryParams = ["api_key": TMDB_API_KEY,
                           "query": query]
        AF.request(TMDB_SEARCH_MOVIES, method: .get, parameters: queryParams)
            .responseDecodable(of: TmdbMovieList.self) { (response: DataResponse<TmdbMovieList>) in
                if let error = response.error {
                    completionHandler?(.error(error))
                } else {
                    switch(response.result) {
                    case .success(let movieList):
                        let movies: [TmdbMovie] = movieList.results ?? []
                        let movieModels = movies.map({ movie -> MovieModel in
                            // Poster path and genre id resolution
                            var model = MovieModel(withMovie: movie)
                            if let posterPath = movie.poster_path {
                                model.posterPath = "https://image.tmdb.org/t/p/w342" + posterPath
                            }
                            if let genreIds = movie.genre_ids {
                                model.genres = genreIds.compactMap({ genreId in
                                    return self.genreCache[genreId]
                                })
                            }
                            return model
                        })
                        completionHandler?(.success(movieModels))
                    case .failure(let error):
                        completionHandler?(.error(error))
                    }
                }
        }
    }
    
    private func loadGenres(completion: @escaping ((Result<Bool>) -> Void)) {
        let queryParams = ["api_key": TMDB_API_KEY]
        AF.request(TMDB_GENRES, method: .get, parameters: queryParams)
            .responseDecodable { (response: DataResponse<GenreList>) in
                switch (response.result) {
                case .success(let genreList):
                    if let genres = genreList.genres {
                        for genre in genres {
                            if let id = genre.id, let name = genre.name {
                                self.genreCache[id] = name
                            }
                        }
                    }
                    completion(.success(true))
                case .failure(let error):
                    completion(.error(error))
                }
        }
    }
}

extension MovieModel {
    fileprivate init(withMovie movie: TmdbMovie) {
        self.backdropPath = movie.backdrop_path
        self.posterPath = movie.poster_path
        self.title = movie.title
        self.overview = movie.overview
        self.releaseDate = movie.release_date
        if let backdropPath = movie.backdrop_path {
            self.backdropPath = "https://image.tmdb.org/t/p/original" + backdropPath
        }
        self.id = movie.id
        self.genres = nil;
    }
}
