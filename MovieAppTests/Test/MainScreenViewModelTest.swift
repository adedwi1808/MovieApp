//
//  MainScreenViewModelTest.swift
//  MovieAppTests
//
//  Created by Ade Dwi Prayitno on 21/01/25.
//

import XCTest
@testable import MovieApp
import RxSwift

final class MainScreenViewModelTest: XCTestCase {
    var sut: MainScreenViewModel!
    var services: MainScreenServicesProtocol!
    var disposableBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        disposableBag = DisposeBag()
        services = MainScreenServices()
        sut = MainScreenViewModel(services: services)
    }
    
    override func tearDown() {
        services = nil
        sut = nil
        disposableBag = nil
        super.tearDown()
    }
    
    func test_getgetPopularMovies_success() async {
        let mockResponse = MoviesResponseModel(
            page: 1,
            results: [MovieResponseModel(
                adult: false,
                backdropPath: "backdropPath",
                genreIDS: [1],
                id: 1,
                originalLanguage: "en",
                originalTitle: "Alfagift The Movie",
                overview: "Food",
                popularity: 10.0,
                posterPath: "Yok Bisa",
                releaseDate: "2020",
                title: "Bismillah Lolos",
                video: true,
                voteAverage: 10.0,
                voteCount: 10
            )],
            totalPages: 2025,
            totalResults: 21
        )
        let networker = NetworkerMock(result: .success(data: mockResponse))
        services = MainScreenServices(networker: networker)
        sut = MainScreenViewModel(services: services)
        
        do {
            try await sut.getPopularMovies()
        } catch _ {
            XCTFail("Fail To Get Movie")
        }
        
        XCTAssertEqual(sut.movies.value.count, 1)
        guard let firstMovie = sut.movies.value.first else {
            XCTFail("No Any Movies")
            return
        }
        XCTAssertEqual(firstMovie.posterPath, "Yok Bisa")
    }
    
    func test_getgetPopularMovies_error() async {
        let expectation = XCTestExpectation(description: "Invalid Movie ID message should be received")
        let networker = NetworkerMock(result: .error(error: .badRequest(message: "Sorry Invalid Movie ID")))
        services = MainScreenServices(networker: networker)
        sut = MainScreenViewModel(services: services)
        
        sut.errorMessage
            .subscribe(onNext: { errorMessage in
                XCTAssertEqual(errorMessage, "Sorry Invalid Movie ID")
                expectation.fulfill()
            })
            .disposed(by: disposableBag)
        
        do {
            try await sut.getPopularMovies()
        } catch _ {
            XCTFail("Fail To Get Movie")
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
