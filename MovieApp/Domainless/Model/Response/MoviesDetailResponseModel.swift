//
//  MoviesDetailResponseModel.swift
//  MovieApp
//
//  Created by Ade Dwi Prayitno on 20/01/25.
//


// MARK: - MoviesDetailResponseModel
struct MoviesDetailResponseModel: Codable {
    let adult: Bool?
    let backdropPath: String?
    let budget: Int?
    let genres: [GenreResponseModel]?
    let homepage: String?
    let id: Int?
    let imdbID: String?
    let originCountry: [String]?
    let originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let revenue, runtime: Int?
    let status, tagline, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case revenue, runtime
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - GenreResponseModel
struct GenreResponseModel: Codable {
    let id: Int?
    let name: String?
}

extension MoviesDetailResponseModel {
    func mapToMovieDetail() -> MovieDetail {
        let genres = genres?.compactMap{$0.name ?? ""}.joined(separator: " · ") ?? ""
        let yearOfRelease = String(releaseDate?.prefix(4) ?? "-")
        let voteAverage = String(format: "%.2f", voteAverage ?? 0.0)
        return MovieDetail(
            title: title ?? "",
            yearOfRelease: yearOfRelease,
            genre: genres,
            durations: runtime?.formatRuntime() ?? "-",
            posterPath: posterPath ?? "",
            voteAverage: "\(voteAverage)/10"
        )
    }
}
