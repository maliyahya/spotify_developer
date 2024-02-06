//
//  File.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 29.01.2024.
//

import Foundation

struct Artist:Codable{
    let id:String
    let name:String
    let type:String
    let external_urls:[String:String]
    let href:String
    let uri:String
    let images:[APIImage]?
}
