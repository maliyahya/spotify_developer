//
//  FeaturedPlaylistCollectionViewCell.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 30.01.2024.
//

import UIKit
import SDWebImage

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    
    static let identifier="FeaturedPlaylistCollectionViewCell"
    
    private let playlistCoverImageView:UIImageView={
       let imageView=UIImageView()
        imageView.image=UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let playlistNameLabel:UILabel={
       let label=UILabel()
        label.numberOfLines=0
        label.font = .systemFont(ofSize: 20,weight: .semibold)
        return label
    }()
    private let creatorNameLabel   :UILabel={
       let label=UILabel()
        label.numberOfLines=0
        label.font = .systemFont(ofSize: 20,weight: .semibold)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(creatorNameLabel)
        contentView.addSubview(playlistNameLabel)
        contentView.backgroundColor = .secondarySystemBackground

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        creatorNameLabel.frame=CGRect(
            x: 3,
            y: contentView.height-44,
            width: contentView.width-6,
            height: 44)
        playlistNameLabel.frame=CGRect(
            x: 3,
            y: contentView.height-70,
            width: contentView.width-6,
            height: 44)
        let imageSize=contentView.height-70
        playlistCoverImageView.frame=CGRect(
            x: 30,
            y: 0,
            width: imageSize,
            height: imageSize)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text=nil
        playlistCoverImageView.image=nil
        creatorNameLabel.text=nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(with viewModel:FeaturedPlaylistCellModel){
        playlistNameLabel.text=viewModel.name
        playlistCoverImageView.sd_setImage(with:viewModel.artworkURL)
        creatorNameLabel.text=viewModel.creatorName
        
    }
}
