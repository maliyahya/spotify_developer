//
//  GenreCollectionViewCell.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 1.02.2024.
//

import UIKit
import SDWebImage

class GenreCollectionViewCell: UICollectionViewCell {
    
    private let imageView:UIImageView={
       let imageView=UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints=false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        imageView.image=UIImage(systemName: "music.quarternote.3",withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
        
        return imageView
    }()
    private let genreTitleLabel:UILabel={
       let label=UILabel()
        label.translatesAutoresizingMaskIntoConstraints=false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    static let identifier="GenreCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(genreTitleLabel)
        configureConstraints()
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        genreTitleLabel.text=nil
        imageView.image=nil
    }
    
  
    
    private func configureConstraints(){
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor,constant: 20),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -30),
            imageView.heightAnchor.constraint(equalToConstant: 90),
            imageView.widthAnchor.constraint(equalToConstant: 90),
            
            genreTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            genreTitleLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: -35)
            
        ]
        )
    }
    func configure(title:String,genreLogo:String){
        genreTitleLabel.text=title
        imageView.sd_setImage(with: URL(string: genreLogo))
    }
    
    
}
