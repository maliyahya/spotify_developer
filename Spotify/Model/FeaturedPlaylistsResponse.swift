//
//  FeaturedPlaylistsResponse.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 29.01.2024.
//

import Foundation

struct FeaturedPlaylistsResponse:Codable {
    let playlists:PlayListResponse
}

struct PlayListResponse:Codable {
    let items:[PlayList]
}

struct User:Codable{
    let display_name:String
    let external_urls:[String:String]
    let id:String
}
