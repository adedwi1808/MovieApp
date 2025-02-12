//
//  MainScreenViewModel.swift
//  MovieApp
//
//  Created by Ade Dwi Prayitno on 20/01/25.
//

import RxSwift
import RxCocoa

class MainScreenViewModel {
    let errorMessage = PublishSubject<String>()
    let movies = BehaviorRelay<[Movie]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    var page: Int = 1
    var maxPage: Int = 1
    var isAbleToLoadMore: Bool = true
    
    private let services: MainScreenServicesProtocol
    
    init(services: MainScreenServicesProtocol) {
        self.services = services
    }
    
    func fetchMovies() {
        Task {
            try await getPopularMovies()
        }
    }
    
    @MainActor
    func getPopularMovies() async throws{
        isLoading.accept(true)
        do {
            let response = try await services.getPopularMovies(endPoint: .popularMovies(page: page))
            mapResponse(response: response)
            isLoading.accept(false)
        } catch let err as NetworkError {
            isLoading.accept(false)
            errorMessage.onNext(err.localizedDescription)
        }
    }
    
    func fetchMoviesNextPage() {
        if isAbleToLoadMore {
            page += 1
            fetchMovies()
        }
    }
    
    private func mapResponse(response moviesResponse: MoviesResponseModel) {
        guard let results = moviesResponse.results else { return }
        let newMovies = results.map { $0.mapToMovie() }
        movies.accept(movies.value + newMovies)
        
        maxPage = moviesResponse.totalPages ?? 1
        isAbleToLoadMore = page <= maxPage
    }
}
