//
//  PlayerControlsView.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 3.02.2024.
//

import UIKit

protocol PlayerControlsViewDelegate:AnyObject {
    func playerControlsViewDidTapPlayPauseButton(_ playerControlView:PlayerControlsView)
    func playerControlsViewDidTapNextButton(_ playerControlView:PlayerControlsView)
    func playerControlsViewDidTapBackButton(_ playerControlView:PlayerControlsView)
    func playerControlsView(_ playerControlsView:PlayerControlsView, didSlideSlider value:Float)
}


struct PlayerControlsViewModel {
    let songName:String
    let subTitle:String
}


class PlayerControlsView: UIView {
    private var isPlaying=true
    weak var delegate:PlayerControlsViewDelegate?
    
    private let songNameLabel:UILabel={
        let label=UILabel()
        label.translatesAutoresizingMaskIntoConstraints=false
        label.numberOfLines=1
        label.font = .systemFont(ofSize: 20,weight: .black)
        label.textColor = .label
        return label
    }()
    private let subTitleLabel:UILabel={
        let label=UILabel()
        label.translatesAutoresizingMaskIntoConstraints=false
        label.numberOfLines=1
        label.font = .systemFont(ofSize: 18,weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    private let backButton:UIButton={
       let button=UIButton()
        button.translatesAutoresizingMaskIntoConstraints=false
        let buttonImage=UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .label
        return button
    }()
    private let nextButton:UIButton={
       let button=UIButton()
        button.translatesAutoresizingMaskIntoConstraints=false
        let buttonImage=UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .label
        return button
    }()
    private let playPauseButton:UIButton={
       let button=UIButton()
        button.translatesAutoresizingMaskIntoConstraints=false
        let buttonImage=UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    
    
    private let slider:UISlider={
       let slider=UISlider()
        slider.translatesAutoresizingMaskIntoConstraints=false
        slider.value=0.5
        return slider
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(subTitleLabel)
        addSubview(songNameLabel)
        addSubview(slider)
        slider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        addSubview(backButton)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        addSubview(playPauseButton)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        configureConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @objc private func didSlideSlider(_ slider:UISlider){
        let value=slider.value
        delegate?.playerControlsView(self, didSlideSlider: value)

    }
    @objc private func didTapNext(){
        delegate?.playerControlsViewDidTapNextButton(self)
    }
    @objc private func didTapBack(){
    }
    @objc private func didTapPlayPause(){
        self.isPlaying = !isPlaying
        delegate?.playerControlsViewDidTapPlayPauseButton(self)
        let pause=UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        let play=UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        playPauseButton.setImage(isPlaying ? pause : play, for: .normal)
    }
    
    func configure(with viewModel:PlayerControlsViewModel){
        songNameLabel.text=viewModel.songName
        subTitleLabel.text=viewModel.subTitle
        
    }
   
    
    private func configureConstraints(){
        NSLayoutConstraint.activate([
            
            songNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            songNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 3),
            
            subTitleLabel.topAnchor.constraint(equalTo: songNameLabel.bottomAnchor, constant: 20),
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 3),
            
            slider.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 20),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -20),
            
            backButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 40),
            backButton.leadingAnchor.constraint(equalTo: slider.leadingAnchor,constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            
            nextButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 40),
            nextButton.trailingAnchor.constraint(equalTo: slider.trailingAnchor,constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 30),
            nextButton.widthAnchor.constraint(equalToConstant: 50),
            
            
            playPauseButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 40),
            playPauseButton.centerXAnchor.constraint(equalTo: slider.centerXAnchor),
            playPauseButton.heightAnchor.constraint(equalToConstant: 30),
            playPauseButton.widthAnchor.constraint(equalToConstant: 50),
            
            
        ])
    }
    
}
