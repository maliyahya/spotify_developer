//
//  SearchResultModel.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 2.02.2024.
//

import Foundation

struct SearchResultModel: Codable {
    let albums: SearchAlbumsResponse
    let artists: SearchArtistsResponse
    let playlists: SearchPlaylistsResponse
    let tracks: SearchTracksResponse
}

struct SearchAlbumsResponse: Codable {
    let items: [Album]
}

struct SearchArtistsResponse: Codable {
    let items: [Artist]
}

struct SearchPlaylistsResponse: Codable {
    let items: [PlayList]
}

struct SearchTracksResponse: Codable {
    let items: [Tracks]
}


enum SearchResult{
    case artist(model:Artist)
    case album(model:Album)
    case track(model:Tracks)
    case playlist(model:PlayList)

}
