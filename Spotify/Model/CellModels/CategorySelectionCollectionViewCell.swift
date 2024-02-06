//
//  CategorySelectionCollectionViewCell.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 2.02.2024.
//

import UIKit
import SDWebImage

class CategorySelectionCollectionViewCell: UICollectionViewCell {
    
    private let albumCoverImage:UIImageView={
       let image=UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints=false
        return image
    }()
    private let categoryNameLabel:UILabel={
       let label=UILabel()
        label.translatesAutoresizingMaskIntoConstraints=false
        label.numberOfLines=2
        label.font = .systemFont(ofSize: 18,weight: .semibold)
        return label
    }()
    static let identifier="CategorySelectionCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(albumCoverImage)
        contentView.addSubview(categoryNameLabel)
        configureConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        albumCoverImage.image=nil
        categoryNameLabel.text=nil
    }
    private func configureConstraints(){
        NSLayoutConstraint.activate([
            albumCoverImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            albumCoverImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100),
            albumCoverImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 5),
            albumCoverImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -5),
            
            categoryNameLabel.topAnchor.constraint(equalTo: albumCoverImage.bottomAnchor,constant: 5),
            categoryNameLabel.leadingAnchor.constraint(equalTo: albumCoverImage.leadingAnchor),
            categoryNameLabel.trailingAnchor.constraint(equalTo: albumCoverImage.trailingAnchor),
            

        ])
    }
    
    func configure(categoryName:String,coverURL:String){
        categoryNameLabel.text=categoryName
        albumCoverImage.sd_setImage(with: URL(string: coverURL))
    }
}
