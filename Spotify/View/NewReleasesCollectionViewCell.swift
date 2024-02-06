//
//  NewReleasesCollectionViewCell.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 30.01.2024.
//

import UIKit
import SDWebImage

class NewReleasesCollectionViewCell: UICollectionViewCell {
    
    static let identifier="NewReleasesCollectionViewCell"
    
    private let albumCoverImageView:UIImageView={
       let imageView=UIImageView()
        imageView.image=UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let albumNameLabel:UILabel={
       let label=UILabel()
        label.numberOfLines=0
        label.font = .systemFont(ofSize: 20,weight: .semibold)
        return label
    }()
    private let numberOfTracksLabel:UILabel={
       let label=UILabel()
        label.numberOfLines=0
        label.font = .systemFont(ofSize: 15,weight: .thin)
        return label
    }()
    private let artistNameLabel:UILabel={
       let label=UILabel()
        label.numberOfLines=0
        label.font = .systemFont(ofSize: 15,weight: .light)
        return label
    }()
    override func layoutSubviews() {
        super.layoutSubviews()
        albumNameLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()
        albumCoverImageView.sizeToFit()
        artistNameLabel.sizeToFit()
        albumCoverImageView.frame=CGRect(
            x: 0,
            y: 0,
            width: 120,
            height: 120)
        albumNameLabel.frame=CGRect(
            x: albumCoverImageView.right+20,
            y: contentView.top+10,
            width: 200,
            height:20)
        numberOfTracksLabel.frame=CGRect(
            x: albumNameLabel.left,
            y: albumNameLabel.bottom+10,
            width:200,
            height: 20)
        artistNameLabel.frame=CGRect(
            x:albumNameLabel.left,
            y:numberOfTracksLabel.bottom+10,
            width: 200,
            height: 20)
    }
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(numberOfTracksLabel)
        contentView.clipsToBounds=true

        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        artistNameLabel.text=nil
        numberOfTracksLabel.text=nil
        albumNameLabel.text=nil
        albumCoverImageView.image=nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel:NewReleasesCellModel){
        artistNameLabel.text=viewModel.artistName
        numberOfTracksLabel.text="Tracks:\(viewModel.numberOfTracks)"
        albumNameLabel.text=viewModel.name
        albumCoverImageView.sd_setImage(with:viewModel.artworkURL , completed: nil)
        
    }
    
}
