//
//  Review.swift
//  MovieApp
//
//  Created by Ade Dwi Prayitno on 21/01/25.
//

import Foundation

struct Review: Codable {
    let authorDetails: AuthorDetails
    let content, createdAt, id: String
}

struct AuthorDetails: Codable {
    let name, username: String
    let avatarPath: String
    let rating: Int
}
