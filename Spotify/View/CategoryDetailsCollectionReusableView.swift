//
//  CategoryDetailsCollectionReusableView.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 2.02.2024.
//

import UIKit

class CategoryDetailsCollectionReusableView: UICollectionReusableView {
    
    static let identifier="CategoryDetailsCollectionReusableView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .brown
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model:CategoryItem){
        
    }
    
}
