//
//  MovieVideosResponseModel.swift
//  MovieApp
//
//  Created by Ade Dwi Prayitno on 20/01/25.
//

// MARK: - MovieVideosResponseModel
struct MovieVideosResponseModel: Codable {
    let id: Int?
    let results: [MovieVideosResultResponseModel]?
}

// MARK: - MovieVideosResultResponseModel
struct MovieVideosResultResponseModel: Codable {
    let type, key: String?

    enum CodingKeys: String, CodingKey {
        case type, key
    }
}

extension MovieVideosResultResponseModel {
    func mapToMovieVideos() -> MovieVideos {
        MovieVideos(key: key ?? "", type: type ?? "")
    }
}
