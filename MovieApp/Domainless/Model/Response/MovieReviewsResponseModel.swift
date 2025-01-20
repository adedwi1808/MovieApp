//
//  MovieReviewsResponseModel.swift
//  MovieApp
//
//  Created by Ade Dwi Prayitno on 21/01/25.
//


// MARK: - MovieReviewsResponseModel
struct MovieReviewsResponseModel: Codable {
    let id, page: Int?
    let results: [MovieReviewsResultResponseModel]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case id, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - MovieReviewsResultResponseModel
struct MovieReviewsResultResponseModel: Codable {
    let authorDetails: AuthorDetailsResponseModel
    let content, createdAt, id: String?

    enum CodingKeys: String, CodingKey {
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
    }
}

// MARK: - AuthorDetailsResponseModel
struct AuthorDetailsResponseModel: Codable {
    let name, username: String?
    let avatarPath: String?
    let rating: Int?

    enum CodingKeys: String, CodingKey {
        case name, username
        case avatarPath = "avatar_path"
        case rating
    }
}

extension MovieReviewsResultResponseModel {
    func mapToMovieReview() -> Review {
        return Review(
            authorDetails: authorDetails.mapToAuthor(),
            content: content ?? "",
            createdAt: createdAt ?? "",
            id: id ?? ""
        )
    }
}

extension AuthorDetailsResponseModel {
    func mapToAuthor() -> AuthorDetails {
        return AuthorDetails(
            name: name ?? "",
            username: username ?? "",
            avatarPath: avatarPath ?? "",
            rating: rating ?? 0
        )
    }
}
