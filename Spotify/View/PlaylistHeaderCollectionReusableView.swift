import UIKit
import SDWebImage

protocol PlaylistHeaderCollectionReusableViewDelegate:AnyObject{
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header:PlaylistHeaderCollectionReusableView)
}



final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "PlaylistHeaderCollectionReusableView"
    weak var delegate :PlaylistHeaderCollectionReusableViewDelegate?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let playlistNameLabel:UILabel={
       let label=UILabel()
        label.translatesAutoresizingMaskIntoConstraints=false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        return label
    }()
    private let playlistDescriptionLabel:UILabel={
       let label=UILabel()
        label.translatesAutoresizingMaskIntoConstraints=false
        label.numberOfLines=2
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 15, weight: .light)
        return label
    }()
    private let channelLabel:UILabel={
       let label=UILabel()
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints=false
        label.font = .systemFont(ofSize: 15, weight: .light)
        return label
    }()
    private let playAllButton:UIButton={
        let button=UIButton()
        button.translatesAutoresizingMaskIntoConstraints=false
        button.backgroundColor = .systemGreen
        let image=UIImage(systemName: "play.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 38, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius=25
        button.layer.masksToBounds=true
        return button
        
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(imageView)
        addSubview(channelLabel)
        addSubview(playlistDescriptionLabel)
        addSubview(playlistNameLabel)
        addSubview(playAllButton)
        configureConstraints()
        playAllButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
    }
    
    private func  configureConstraints(){
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            playlistNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            playlistNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            playlistDescriptionLabel.topAnchor.constraint(equalTo: playlistNameLabel.bottomAnchor, constant: 10),
            playlistDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            playlistDescriptionLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -30),
            
            channelLabel.topAnchor.constraint(equalTo: playlistDescriptionLabel.bottomAnchor,constant: 10),
            channelLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            playAllButton.topAnchor.constraint(equalTo: playlistDescriptionLabel.bottomAnchor,constant: 2),
            playAllButton.leadingAnchor.constraint(equalTo: imageView.trailingAnchor,constant: 5),
            playAllButton.heightAnchor.constraint(equalToConstant: 60),
            playAllButton.widthAnchor.constraint(equalToConstant: 60)
            
            
            
        ])
    }
    @objc private func didTapPlayAll(){
        delegate?.playlistHeaderCollectionReusableViewDidTapPlayAll(self)
        
    }
    func configure(headerViewModel: PlaylistHeaderViewModel) {
        imageView.sd_setImage(with: headerViewModel.artworkURL,completed: nil)
        playlistNameLabel.text=headerViewModel.name
        playlistDescriptionLabel.text=headerViewModel.description
        channelLabel.text=headerViewModel.ownerName
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
