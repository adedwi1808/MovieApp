//
//  Result.swift
//  MovieAppTests
//
//  Created by Ade Dwi Prayitno on 21/01/25.
//

import Foundation
@testable import MovieApp

enum Result {
    case success(data: Decodable)
    case error(error: NetworkError)
}
