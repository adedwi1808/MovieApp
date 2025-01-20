//
//  MainScreenServices.swift
//  MovieApp
//
//  Created by Ade Dwi Prayitno on 20/01/25.
//

import Foundation


protocol MainScreenServicesProtocol: AnyObject {
    var networker: NetworkerProtocol { get }
    
    func getPopularMovies(endPoint: NetworkFactory) async throws -> MoviesResponseModel
}

final class MainScreenServices: MainScreenServicesProtocol {
    var networker: any NetworkerProtocol
    
    init(networker: any NetworkerProtocol = Networker()) {
        self.networker = networker
    }
    
    func getPopularMovies(endPoint: NetworkFactory) async throws -> MoviesResponseModel {
        try await networker.taskAsync(type: MoviesResponseModel.self, endPoint: endPoint, isMultipart: false)
    }
}
