//
//  CategoryModel.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 2.02.2024.
//

import Foundation




struct CategoryModel: Codable {
    let categories: Categories
}

struct Categories: Codable {
    let href: String
    let items: [CategoryItem]
    let limit: Int
    let next: String
    let offset: Int
    let previous: String?
    let total: Int
}

struct CategoryItem: Codable {
    let href: String
    let icons: [Icon]
    let id: String
    let name: String
}

struct Icon: Codable {
    let height: Int
    let url: String
    let width: Int
}
