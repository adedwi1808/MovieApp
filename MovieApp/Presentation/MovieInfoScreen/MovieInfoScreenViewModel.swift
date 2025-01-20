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
    
    let detail = BehaviorRelay<MovieDetail?>(value: nil)
    
    init(id: Int, services: MovieInfoScreenServicesProtocol) {
        self.id = id
        self.services = services
    }
    
    func fetchMovies() {
        Task {
            try await getMovieDetail()
        }
    }
    
    @MainActor
    func getMovieDetail() async throws {
        do {
            let response = try await services.getMovieDetail(endPoint: .movieDetail(id: id))
            mapMovieDetailResponse(response)
        } catch let err as NetworkError {
            print(err.localizedDescription)
        }
    }
    
    private func mapMovieDetailResponse(_ response: MoviesDetailResponseModel) {
        detail.accept(response.mapToMovieDetail())
    }
}
