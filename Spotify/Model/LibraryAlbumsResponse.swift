//
//  LibraryAlbumsResponse.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 6.02.2024.
//

import Foundation

struct LibraryAlbumsResponse:Codable{
    let href:String
    let limit:Int
    let next:String
    let offset:Int
    let previous:String
    let total:Int
    let items:SavedAlbumObject
}


struct SavedAlbumObject:Codable{
    let album:Album
    let added_at:[String]
}
