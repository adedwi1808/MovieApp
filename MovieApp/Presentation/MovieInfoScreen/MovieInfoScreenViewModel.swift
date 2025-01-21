//
//  MovieInfoScreenViewModel.swift
//  MovieApp
//
//  Created by Ade Dwi Prayitno on 20/01/25.
//

import RxSwift
import RxCocoa

class MovieInfoScreenViewModel {
    private let id: Int
    private let services: MovieInfoScreenServicesProtocol
    let errorMessage = PublishSubject<String>()
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    let detail = BehaviorRelay<MovieDetail?>(value: nil)
    let trailer = BehaviorRelay<MovieVideos?>(value: nil)
    let reviews = BehaviorRelay<[Review]>(value: [])
    private var reviewPage: Int = 1
    private var maxPage: Int = 1
    var isAbleToLoadMore: Bool = true
    
    init(id: Int, services: MovieInfoScreenServicesProtocol) {
        self.id = id
        self.services = services
    }
    
    func fetchMovies() {
        Task {
            try await getMovieDetail()
            try await getMovieVideos()
            try await getMovieReviews()
        }
    }
    
    @MainActor
    func getMovieDetail() async throws {
        isLoading.accept(true)
        do {
            let response = try await services.getMovieDetail(endPoint: .movieDetail(id: id))
            mapMovieDetailResponse(response)
            isLoading.accept(false)
        } catch let err as NetworkError {
            isLoading.accept(false)
            errorMessage.onNext(err.localizedDescription)
        }
    }
    
    private func mapMovieDetailResponse(_ response: MoviesDetailResponseModel) {
        detail.accept(response.mapToMovieDetail())
    }
    
    @MainActor
    func getMovieVideos() async throws {
        isLoading.accept(true)
        do {
            let response = try await services.getMovieVideos(endPoint: .movieVideos(id: id))
            mapMovieVideosResponse(response)
            isLoading.accept(false)
        } catch let err as NetworkError {
            isLoading.accept(false)
            errorMessage.onNext(err.localizedDescription)
        }
    }
    
    private func mapMovieVideosResponse(_ response: MovieVideosResponseModel) {
        guard let firstTrailer = response.results?.first(where: { $0.type == "Trailer" }) else { return }
        trailer.accept(firstTrailer.mapToMovieVideos())
    }
    
    @MainActor
    func getMovieReviews() async throws {
        do {
            let response = try await services.getMovieReviews(endPoint: .movieReviews(id: id, page: reviewPage))
            mapMovieReviewsResponse(response)
        } catch let err as NetworkError {
            errorMessage.onNext(err.localizedDescription)
        }
    }
    
    private func mapMovieReviewsResponse(_ response: MovieReviewsResponseModel) {
        guard let newReviews = response.results?.compactMap({$0.mapToMovieReview()}) else { return }
        reviews.accept(reviews.value + newReviews)
        
        maxPage = response.totalPages ?? 1
        isAbleToLoadMore = reviewPage <= maxPage
    }
    
    func fetchReviewsNextPage() {
        if isAbleToLoadMore {
            reviewPage += 1
            fetchReviews()
        }
    }
    
    private func fetchReviews() {
        Task {
            try await getMovieReviews()
        }
    }
}
