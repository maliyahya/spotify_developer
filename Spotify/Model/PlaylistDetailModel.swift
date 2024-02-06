//
//  NewModel.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 1.02.2024.
//

import Foundation

struct PlaylistDetailModel: Codable {
    let collaborative: Bool?
    let external_urls: [String: String]
    let followers: Followerss
    let href: String
    let id: String
    let images: [PlaylistImage]
    let primary_color: String?
    let name: String
    let description: String
    let type: String
    let uri: String
    let owner: PlaylistOwner
    let snapshot_id: String
    let tracks: PlaylistTracks
}

struct Followerss: Codable {
    let href: String?
    let total: Int
}

struct PlaylistImage: Codable {
    let url: String
    let height: Int?
    let width: Int?
}

struct PlaylistOwner: Codable {
    let href: String
    let id: String
    let type: String
    let uri: String
    let display_name: String
    let external_urls: [String: String]
}

struct PlaylistTracks: Codable {
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let href: String
    let total: Int
    let items: [PlaylistTrack]
}

struct PlaylistTrack: Codable {
    let added_at: String
    let track: AudioTrack
}

struct Tracks: Codable {
    let preview_url: String?
    let available_markets: [String]
    let explicit: Bool
    let type: String
    let album: Albums
    let artists: [Artists]
    let disc_number: Int
    let track_number: Int
    let duration_ms: Int
    let external_ids: ExternalIds
    let external_urls: [String: String]
    let href: String
    let id: String
    let name: String
    let popularity: Int
    let uri: String
    let is_local: Bool
}

struct Albums: Codable {
    let available_markets: [String]
    let type: String
    let album_type: String
    let href: String
    let id: String
    let images: [AlbumImage]
    let name: String
    let release_date: String
    let release_date_precision: String
    let uri: String
    let artists: [Artists]
    let external_urls: [String: String]
    let total_tracks: Int
}

struct AlbumImage: Codable {
    let url: String
    let width: Int
    let height: Int
}

struct Artists: Codable {
    let external_urls: [String: String]
    let href: String
    let id: String
    let name: String
    let type: String
    let uri: String
}

struct ExternalIds: Codable {
    let isrc: String
}
