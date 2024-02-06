//
//  LibraryViewController.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 28.01.2024.
//

import UIKit

class LibraryViewController: UIViewController {
    
    
    
   private let playlistVC=LibraryPlaylistViewController()
   private let albumVC=LibraryAlbumViewController()
    
    private let scrollView:UIScrollView={
       let scrollView=UIScrollView()
        scrollView.isPagingEnabled=true
        return scrollView
    }()
    
    let toggleView=LibraryToggleView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        view.addSubview(toggleView)
        toggleView.delegate=self
        scrollView.contentSize=CGSize(width: view.width*2+110, height:  500)
        scrollView.delegate=self
        addChildren()

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame=CGRect(x: 0, y: view.safeAreaInsets.top+55, width: 500,
                                height: 500)
        toggleView.frame=CGRect(x: 0, y: view.safeAreaInsets.top, width: 200, height: 200)
        
        
    }
    
    private func addChildren(){
        addChild(playlistVC)
        scrollView.addSubview(playlistVC.view)
        playlistVC.view.frame=CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
        playlistVC.didMove(toParent: self)
        
        addChild(albumVC)
        scrollView.addSubview(albumVC.view)
        albumVC.view.frame=CGRect(x: view.width, y: 0, width: scrollView.width, height: scrollView.height)
        albumVC.didMove(toParent: self)
        updateBarButtons()
    }
    
    private func updateBarButtons(){
        switch toggleView.state {
        case .playlist:
            navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        case .album:
            navigationItem.rightBarButtonItem=nil
        }
    }
    
    @objc private func didTapAdd(){
        playlistVC.showCreatePlayListAlert()
    }

  

}


extension LibraryViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.contentOffset.x >= (view.width-100)){
            toggleView.update(for: .album)
            updateBarButtons()
        }
        else{
            toggleView.update(for: .playlist)
            updateBarButtons()

        }
    }
    
}


extension LibraryViewController:LibraryToggleViewDelegate{
    func libraryToggleViewDidTapPlaylists() {
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    func libraryToggleViewDidTapAlbums() {
        scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
    }
    
    
}
