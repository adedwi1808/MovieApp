//
//  MovieInfoScreenServices.swift
//  MovieApp
//
//  Created by Ade Dwi Prayitno on 20/01/25.
//

import Foundation

protocol MovieInfoScreenServicesProtocol: AnyObject {
    var networker: NetworkerProtocol { get }
    
    func getMovieDetail(endPoint: NetworkFactory) async throws -> MoviesDetailResponseModel
    func getMovieVideos(endPoint: NetworkFactory) async throws -> MovieVideosResponseModel
}

final class MovieInfoScreenServices: MovieInfoScreenServicesProtocol {
    var networker: any NetworkerProtocol
    
    init(networker: any NetworkerProtocol = Networker()) {
        self.networker = networker
    }
    
    func getMovieDetail(endPoint: NetworkFactory) async throws -> MoviesDetailResponseModel {
        try await networker.taskAsync(type: MoviesDetailResponseModel.self, endPoint: endPoint, isMultipart: false)
    }
    
    func getMovieVideos(endPoint: NetworkFactory) async throws -> MovieVideosResponseModel {
        try await networker.taskAsync(type: MovieVideosResponseModel.self, endPoint: endPoint, isMultipart: false)
    }
}
