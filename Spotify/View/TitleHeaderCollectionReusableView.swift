//
//  TitleHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 1.02.2024.
//

import Foundation
import UIKit


class TitleHeaderCollectionReusableView:UICollectionReusableView{
    
    static let identifier="TitleHeaderCollectionReusableView"
    private let label:UILabel={
       let label=UILabel()
        label.translatesAutoresizingMaskIntoConstraints=false
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.numberOfLines=1
        label.textColor = .label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(label)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    private func configureConstraints(){
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 5),
            label.heightAnchor.constraint(equalToConstant: 25),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 5)
        ])
    }
    func configure(with title:String){
        label.text=title
    }
    
}
