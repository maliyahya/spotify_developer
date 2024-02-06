//
//  SearchResultDefaultTableViewCell.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 2.02.2024.
//

import UIKit
import SDWebImage


struct DefaultTableModel{
    let title:String
    let subtitle:String
    let imageURL:String
}
class SearchResultDefaultTableViewCell: UITableViewCell {
    private let coverImageView:UIImageView={
       let imageView=UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints=false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let displayNameLabel:UILabel={
       let label=UILabel()
        label.translatesAutoresizingMaskIntoConstraints=false
        label.font = .systemFont(ofSize: 17,weight: .heavy)
        label.numberOfLines=1
        return label
    }()
    private let subtextLabel:UILabel={
       let label=UILabel()
        label.translatesAutoresizingMaskIntoConstraints=false
        label.font = .systemFont(ofSize: 14,weight: .medium)
        label.numberOfLines=1
        return label
    }()
    static let identifier="SearchResultDefaultTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(coverImageView)
        contentView.addSubview(displayNameLabel)
        contentView.addSubview(subtextLabel)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints(){
        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            coverImageView.heightAnchor.constraint(equalToConstant: 50),
            coverImageView.widthAnchor.constraint(equalToConstant: 50),
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            
            displayNameLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor,constant: 10),
            displayNameLabel.topAnchor.constraint(equalTo: coverImageView.topAnchor),
            
            subtextLabel.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor,constant: 2),
            subtextLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor,constant: 10),
            subtextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            
            
        ])
    }
    
    
    func configure(model:DefaultTableModel){
        coverImageView.sd_setImage(with: URL(string: model.imageURL))
        displayNameLabel.text=model.title
        subtextLabel.text=model.subtitle
        
    }
}
