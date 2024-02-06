//
//  UserModel.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 29.01.2024.
//

import Foundation

struct UserModel:Codable {
    let country: String
    let display_name: String
    let explicit_content: ExplicitContent
    let external_urls: ExternalUrls
    let followers: Followers
    let href: String
    let id: String
    let images: [Image]
    let product: String
    let type: String
    let uri: String
}

struct ExplicitContent:Codable {
    let filter_enabled: Bool
    let filter_locked: Bool
}

struct ExternalUrls:Codable {
    let spotify: String
}

struct Followers:Codable {
    let href: String?
    let total: Int
}

struct Image:Codable {
    let height: Int
    let url: String
    let width: Int
}

