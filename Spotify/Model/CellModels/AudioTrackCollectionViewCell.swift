//
//  AudioTrackCollectionViewCell.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 1.02.2024.
//

import UIKit

class AudioTrackCollectionViewCell: UICollectionViewCell {
    
    
    
    
    static let identifier="AudioTrackCollectionViewCell"
    
  
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
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds=true
        configureConstraints()

        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        artistNameLabel.text=nil
        albumNameLabel.text=nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints(){
        artistNameLabel.sizeToFit()
        albumNameLabel.sizeToFit()
        NSLayoutConstraint.activate([
           
            
            albumNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20),
            albumNameLabel.widthAnchor.constraint(equalToConstant: 280),
            albumNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 3),
            
            artistNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
            artistNameLabel.leadingAnchor.constraint(equalTo: albumNameLabel.leadingAnchor),
            
            
            
        ])
    }
    func configure(with model:AudioTrackCell){
        artistNameLabel.text=model.artistName
        albumNameLabel.text=model.name
        
    }
    
}
