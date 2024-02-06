//
//  Section.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 29.01.2024.
//

import Foundation

struct Section {
    let title:String
    let options:[Option]
    
}

struct Option {
    let title:String
    let handler:()->Void
}
