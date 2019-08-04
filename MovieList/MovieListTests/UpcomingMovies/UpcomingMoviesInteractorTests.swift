//
//  MovieListTests.swift
//  MovieListTests
//
//  Created by Marcelo on 31/07/19.
//  Copyright © 2019 Marcelo. All rights reserved.
//

import XCTest
@testable import MovieList

class UpcomingMoviesInteractorTests: XCTestCase {

    var presenter: MockPresenter!
    var interactor: UpcomingMoviesInteractor!
    
    override func setUp() {
        interactor = UpcomingMoviesInteractor(withService: MockService())
        presenter = MockPresenter()
        interactor.presenter = presenter
        presenter.interactor = interactor
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit() {
        XCTAssert(interactor != nil)
    }
    
    func testLoad() {
        presenter.loadSucceededFulfillment = expectation(description: "Movie Loaded")
        interactor.loadNextUpcomingMoviesPage()
        waitForExpectations(timeout: 2, handler: nil)
        if let movies = presenter.movies {
            XCTAssert(!movies.isEmpty)
        } else {
            XCTFail("Interactor failed to call presenter")
        }
        
    }
    
    
    class MockPresenter: UpcomingMoviesPresenterProtocol, UpcomingMoviesInteractorOutputProtocol {
        var view: UpcomingMoviesViewProtocol?
        
        var interactor: UpcomingMoviesInteractorInputProtocol?
        
        var router: UpcomingMoviesRouterProtocol?
        var loadSucceededFulfillment: XCTestExpectation!
        var movies: [MovieModel]?
        
        func viewDidLoad() {
        }
        
        func userDidRequestMoreMovies() {
        }
        
        func userDidSelectMovie(movie: MovieViewModel) {
        }
        
        func userDidSearchMovies(query: String) {
        }
        
        func searchDidFinish() {
        }
        
        func didRetrieveMovies(movies: [MovieModel]) {
            self.movies = movies
            loadSucceededFulfillment.fulfill()
        }
        
        func errorDidOccur(error: Error) {
            
        }
        
        func searchDidFinish(movies: [MovieModel]) {
        }
    }
    
    class MockService: MovieServiceProtocol {
        
        func loadNextUpcomingMovies(completionHandler: ((Result<[MovieModel]>) -> Void)?) {
           completionHandler?(.success(kUpcomingMovies))
        }
        
        func getMovieDetails(movieId id: Int, completion completionHandler: ((Result<MovieModel>) -> Void)?) {
            completionHandler?(.error(NSError(domain: "Tests", code: 0, userInfo: nil)))
        }
        
        func searchMovies(query: String, completion completionHandler: ((Result<[MovieModel]>) -> Void)?) {
            completionHandler?(.success([]))
        }
    }

}
