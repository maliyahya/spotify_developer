//
//  AudioTrackModel.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 29.01.2024.
//

import Foundation

struct AudioTrack:Codable{
    var album:Album?
    let artists:[Artist]
    let available_markets:[String]
    let disc_number:Int
    let duration_ms:Int
    let explicit:Bool
    let external_urls:[String:String]
    let id:String
    let name:String
    let popularity:Int?
    let mainName:String?
    let preview_url:String?
    
}


struct AudioTrackCell:Codable{
    let name:String
    let artistName:String
}
