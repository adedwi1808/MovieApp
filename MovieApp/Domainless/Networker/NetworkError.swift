//
//  NetworkError.swift
//  MovieApp
//
//  Created by Ade Dwi Prayitno on 20/01/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case badRequest(message: String)
    case middlewareError(code: Int, message: String)
    case internetError(message: String)
    case decodingError(message: String)
    case unAuthorized
    
    var localizedDescription: String {
        switch self {
        case .middlewareError(_, let message):
            return message
        case .internetError:
            return ""
        case .decodingError(let message):
            return message
        case .unAuthorized:
            return "unauthorized"
        case .badRequest(let message):
            return message
        }
    }
    
    var isUnAuthorized: Bool {
        switch self {
        case .middlewareError:
            return false
        case .internetError:
            return false
        case .decodingError:
            return false
        case .unAuthorized:
            return true
        case .badRequest:
            return false
        }
    }
}

enum ErrorState {
    case idle
    case middlewareError
    case internetError
    case unAuthorized
}
