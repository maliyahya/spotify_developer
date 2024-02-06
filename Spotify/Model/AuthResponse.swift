//
//  AuthResponse.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 28.01.2024.
//

import Foundation

struct AuthResponse : Codable{
    let access_token:String
    let expires_in:Int
    let refresh_token:String?
    let scope:String
    let token_type:String
    
}
