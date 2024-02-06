//
//  PlayListModel.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 29.01.2024.
//

import Foundation


struct PlayList:Codable{
    let description:String
    let external_urls:[String:String]
    let id:String
    let images:[APIImage]
    let name:String
    let owner:User
}
