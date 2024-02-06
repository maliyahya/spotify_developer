//
//  AlbumDetailModel.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 31.01.2024.
//

import Foundation

struct AlbumDetailModel: Codable {
    let album_type: String?
    let artists: [Artist]
    let available_markets: [String]
    let external_urls: [String:String]
    let id: String
    let images: [Image]
    let label: String
    let name: String
    let tracks:TracksResponse
 
}
struct TracksResponse:Codable{
    let items:[AudioTrack]
}
