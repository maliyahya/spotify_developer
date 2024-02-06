//
//  CategorySelectionModel.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 2.02.2024.
//

import Foundation

struct Playlist {
    let collaborative: Int
    let description: String
    let externalURLs: ExternalURLs
    let href: String
    let id: String
    let images: [Image]
    let name: String
    let owner: Owner
    let primaryColor: String
    let isPublic: Int
    let snapshotID: String
    let tracks: Track
    let type: String
    let uri: String
}

struct ExternalURLs {
    let spotify: String
}



struct Owner {
    let displayName: String
    let externalURLs: ExternalURLs
    let href: String
    let id: String
    let type: String
    let uri: String
}

struct Track {
    let href: String
    let total: Int
}

struct Playlists {
    let href: String
    let items: [Playlist]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}

struct SpotifyResponse {
    let message: String
    let playlists: Playlists
}
