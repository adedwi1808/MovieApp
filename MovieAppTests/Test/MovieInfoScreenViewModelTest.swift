//
//  MovieInfoScreenViewModelTest.swift
//  MovieAppTests
//
//  Created by Ade Dwi Prayitno on 21/01/25.
//

import XCTest
@testable import MovieApp
import RxSwift

final class MovieInfoScreenViewModelTest: XCTestCase {
    var sut: MovieInfoScreenViewModel!
    var services: MovieInfoScreenServicesProtocol!
    var disposableBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        disposableBag = DisposeBag()
        services = MovieInfoScreenServices()
        sut = MovieInfoScreenViewModel(id: 2025, services: services)
    }
    
    override func tearDown() {
        services = nil
        sut = nil
        disposableBag = nil
        super.tearDown()
    }
    
    func test_getMovieDetail_success() async {
        let mockResponse = MoviesDetailResponseModel(
            adult: false,
            backdropPath: "Ade",
            budget: 20_000,
            genres: [.init(id: 1, name: "iOS Dev")],
            homepage: "Beranda",
            id: 1808,
            imdbID: "/hehehe",
            originCountry: ["USA"],
            originalLanguage: "en",
            originalTitle: "Alfa Gift Test",
            overview: "Overview",
            popularity: 20.0,
            posterPath: "Alfa",
            releaseDate: "2020",
            revenue: 2_000_000,
            runtime: 10,
            status: "released",
            tagline: "cakep",
            title: "Alfa",
            video: false,
            voteAverage: 9.0,
            voteCount: 1000
        )
        let networker = NetworkerMock(result: .success(data: mockResponse))
        services = MovieInfoScreenServices(networker: networker)
        sut = MovieInfoScreenViewModel(id: 2025, services: services)
        
        do {
            try await sut.getMovieDetail()
        } catch _ {
            XCTFail("Fail To Get Movie Detail")
        }
        
        guard let detail = sut.detail.value else {
            XCTFail("No Any Movies")
            return
        }
        
        XCTAssertEqual(detail.title, "Alfa")
        XCTAssertEqual(detail.genre, "iOS Dev")
    }
    
    func test_getMovieDetail_error() async {
        let expectation = XCTestExpectation(description: "unAuthorized message should be received")
        let networker = NetworkerMock(result: .error(error: .unAuthorized))
        services = MovieInfoScreenServices(networker: networker)
        sut = MovieInfoScreenViewModel(id: 2025, services: services)
        
        sut.errorMessage
            .subscribe(onNext: { errorMessage in
                XCTAssertEqual(errorMessage, "unauthorized")
                expectation.fulfill()
            })
            .disposed(by: disposableBag)
        
        do {
            try await sut.getMovieDetail()
        } catch _ {
            XCTFail("Fail To Get Movie Detail")
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func test_getMovieVideos_success() async {
        let mockResponse = MovieVideosResponseModel(id: 2025, results: [.init(type: "Trailer", key: "/ALFA2025")])
        let networker = NetworkerMock(result: .success(data: mockResponse))
        services = MovieInfoScreenServices(networker: networker)
        sut = MovieInfoScreenViewModel(id: 2025, services: services)
        
        do {
            try await sut.getMovieVideos()
        } catch _ {
            XCTFail("Fail To Get Movie Trailer")
        }
        
        guard let trailer = sut.trailer.value else {
            XCTFail("No Any Trailer")
            return
        }
        
        XCTAssertEqual(trailer.type, "Trailer")
        XCTAssertEqual(trailer.key, "/ALFA2025")
    }
    
    func test_getMovieVideos_error() async {
        let expectation = XCTestExpectation(description: "Decoder Fail message should be received")
        let networker = NetworkerMock(result: .error(error: .decodingError(message: "Fail To Decode")))
        services = MovieInfoScreenServices(networker: networker)
        sut = MovieInfoScreenViewModel(id: 2025, services: services)
        
        sut.errorMessage
            .subscribe(onNext: { errorMessage in
                XCTAssertEqual(errorMessage, "Fail To Decode")
                expectation.fulfill()
            })
            .disposed(by: disposableBag)
        
        do {
            try await sut.getMovieVideos()
        } catch _ {
            XCTFail("Fail To Get Movie Trailer")
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func test_getMovieReviews_success() async {
        let mockResponse = MovieReviewsResponseModel(
            id: 2025,
            page: 1,
            results: [
                MovieReviewsResultResponseModel(
                    authorDetails: .init(name: "Ade", username: "Ade", avatarPath: "/", rating: 10),
                    content: "This is Alfagift Test",
                    createdAt: "21-01-2025",
                    id: "1808"
                ),
                MovieReviewsResultResponseModel(
                    authorDetails: .init(name: "Alfa", username: "Alfa", avatarPath: "/", rating: 10),
                    content: "Hello Adee",
                    createdAt: "21-01-2025",
                    id: "2101"
                ),],
            totalPages: 2024,
            totalResults: 2025
        )
        let networker = NetworkerMock(result: .success(data: mockResponse))
        services = MovieInfoScreenServices(networker: networker)
        sut = MovieInfoScreenViewModel(id: 2025, services: services)
        
        do {
            try await sut.getMovieReviews()
        } catch _ {
            XCTFail("Fail To Get Movie Trailer")
        }
        
        XCTAssertEqual(sut.reviews.value.count, 2)
        
        guard let lastReviews = sut.reviews.value.last else {
            XCTFail("No Any Reviews")
            return
        }
        XCTAssertEqual(lastReviews.content, "Hello Adee")
        XCTAssertEqual(lastReviews.createdAt, "21-01-2025")
    }
    
    func test_getMovieReviews_error() async {
        let expectation = XCTestExpectation(description: "Server Error message should be received")
        let networker = NetworkerMock(result: .error(error: .middlewareError(code: 404, message: "Something Wrong With Server")))
        services = MovieInfoScreenServices(networker: networker)
        sut = MovieInfoScreenViewModel(id: 2025, services: services)
        
        sut.errorMessage
            .subscribe(onNext: { errorMessage in
                XCTAssertEqual(errorMessage, "Something Wrong With Server")
                expectation.fulfill()
            })
            .disposed(by: disposableBag)
        
        do {
            try await sut.getMovieReviews()
        } catch _ {
            XCTFail("Fail To Get Movie Reviews")
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
