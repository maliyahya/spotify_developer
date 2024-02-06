//
//  LibraryToggleView.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 5.02.2024.
//

import UIKit

protocol LibraryToggleViewDelegate:AnyObject {
    func libraryToggleViewDidTapPlaylists()
    func libraryToggleViewDidTapAlbums()
}

enum State{
    case playlist
    case album
}

class LibraryToggleView: UIView {
    
    var state:State = .playlist
    weak var delegate:LibraryToggleViewDelegate?
    private let playlistButton:UIButton={
       let button=UIButton()
        button.setTitle("Playlists", for: .normal)
        button.setTitleColor(.label , for: .normal)
        return button
    }()
    private let albumButton:UIButton={
       let button=UIButton()
        button.setTitle("Albums", for: .normal)
        button.setTitleColor(.label , for: .normal)
        return button
    }()
    private let indicatorView:UIView={
        let view=UIView()
        view.backgroundColor = .systemGreen
        view.layer.masksToBounds=true
        view.layer.cornerRadius=4
        return view
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(playlistButton)
        addSubview(albumButton)
        addSubview(indicatorView)
        playlistButton.addTarget(self, action: #selector(didTapPlaylist), for: .touchUpInside)
        albumButton.addTarget(self, action: #selector(didTapAlbum), for: .touchUpInside)

        
    }
  
    
    @objc private func didTapPlaylist(){
        state = .playlist
        UIView.animate(withDuration: 0.2){
            self.layoutIndicator()
        }
        self.delegate?.libraryToggleViewDidTapPlaylists()
        
    }
    @objc private func didTapAlbum(){
        state = .album
        UIView.animate(withDuration: 0.2){
            self.layoutIndicator()
        }
        self.delegate?.libraryToggleViewDidTapAlbums()
        
    }
    func update(for state:State){
        self.state = state
        UIView.animate(withDuration: 0.2){
            self.layoutIndicator()
        }
    }
    
    private func layoutIndicator(){
        switch state {
        case .playlist:
            indicatorView.frame=CGRect(x: 0, y: playlistButton.bottom, width: 100, height: 3)
        case .album:
            indicatorView.frame=CGRect(x: 100, y: playlistButton.bottom, width: 100, height: 3)

        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playlistButton.frame=CGRect(x: 0, y: 0, width: 100, height: 50)
        albumButton.frame=CGRect(x: playlistButton.right, y: 0, width: 100, height: 50)
        layoutIndicator()
    }
    
  
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
