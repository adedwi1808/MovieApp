//
//  NetworkErrorResponseModel.swift
//  MovieApp
//
//  Created by Ade Dwi Prayitno on 21/01/25.
//

// MARK: - NetworkErrorResponseModel
struct NetworkErrorResponseModel: Codable {
    let success: Bool?
    let statusCode: Int?
    let statusMessage: String?

    enum CodingKeys: String, CodingKey {
        case success
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
