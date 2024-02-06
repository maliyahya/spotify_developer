//
//  RecommendedTrackCollectionViewCell.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 30.01.2024.
//

import UIKit
import SDWebImage

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RecommendedTrackCollectionViewCell"
    private let albumCoverImageView:UIImageView={
       let imageView=UIImageView()
        imageView.image=UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints=false
        return imageView
    }()
    private let albumNameLabel:UILabel={
       let label=UILabel()
        label.numberOfLines=1
        label.font = .systemFont(ofSize: 15,weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints=false

        return label
    }()
    private let artistNameLabel:UILabel={
       let label=UILabel()
        label.numberOfLines=1
        label.font = .systemFont(ofSize: 15,weight: .light)
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds=true
        configureConstraints()

        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        artistNameLabel.text=nil
        albumNameLabel.text=nil
        albumCoverImageView.image=nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints(){
        artistNameLabel.sizeToFit()
        albumNameLabel.sizeToFit()
        NSLayoutConstraint.activate([
            
            albumCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            albumCoverImageView.heightAnchor.constraint(equalTo:contentView.heightAnchor),
            albumCoverImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor),
            
            albumNameLabel.leadingAnchor.constraint(equalTo: albumCoverImageView.trailingAnchor,constant: 20),
            albumNameLabel.widthAnchor.constraint(equalToConstant: 280),
            albumNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 3),
            
            artistNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
            artistNameLabel.leadingAnchor.constraint(equalTo: albumNameLabel.leadingAnchor),
            
            
            
        ])
    }
    
    func configure(with viewModel:RecommendedTrackCellModel){
        artistNameLabel.text=viewModel.artistName
        albumNameLabel.text=viewModel.name
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL)
        
    }
    
}
