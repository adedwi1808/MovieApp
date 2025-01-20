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
    let trailer = BehaviorRelay<MovieVideos?>(value: nil)
    
    init(id: Int, services: MovieInfoScreenServicesProtocol) {
        self.id = id
        self.services = services
    }
    
    func fetchMovies() {
        Task {
            try await getMovieDetail()
            try await getMovieVideos()
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
    
    @MainActor
    func getMovieVideos() async throws {
        do {
            let response = try await services.getMovieVideos(endPoint: .movieVideos(id: id))
            mapMovieVideosResponse(response)
        } catch let err as NetworkError {
            print(err.localizedDescription)
        }
    }
    
    private func mapMovieVideosResponse(_ response: MovieVideosResponseModel) {
        guard let firstTrailer = response.results?.first(where: { $0.type == "Trailer" }) else { return }
        trailer.accept(firstTrailer.mapToMovieVideos())
    }
}
