//
//  NetworkerMock.swift
//  MovieAppTests
//
//  Created by Ade Dwi Prayitno on 21/01/25.
//

@testable import MovieApp
import Foundation
import XCTest

class NetworkerMock: NetworkerProtocol {
    var result: Result? = nil
    init(result: Result?) {
        self.result = result
    }
    
    func taskAsync<T>(type: T.Type, endPoint: MovieApp.NetworkFactory, isMultipart: Bool) async throws -> T where T: Decodable {
        switch result {
        case .success(let data):
            return data as! T
        case .error(let error):
            throw error
        case .none:
            return try JSONDecoder().decode(type.self, from: Data())
        }
    }
}
