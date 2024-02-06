//
//  PlayerViewController.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 2.02.2024.
//

import UIKit


protocol PlayerViewControllerDelegate:AnyObject{
    func didTapPlayPause()
    func didTapForward()
    func didTapBackwards()
    func didSlideSlider(_ value:Float)
}



class PlayerViewController: UIViewController {
    
    weak var dataSource:PlayerDataSource?
    weak var delegate:PlayerViewControllerDelegate?
    private var playerControlView=PlayerControlsView()
    private let imageView:UIImageView={
       let image=UIImageView()
        image.backgroundColor = .systemGreen
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(playerControlView)
        playerControlView.delegate=self
        imageView.frame=CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: 450)
        playerControlView.frame=CGRect(x: 10, y: imageView.bottom+10, width: view.width-20, height: view.height-imageView.height-20)
        configureBarButtons()
        configure()
        


    }
     func refreshUI(){
        configure()
    }
    
    private func configure(){
        imageView.sd_setImage(with: URL(string: dataSource?.imageURL ?? ""),completed: nil)
        playerControlView.configure(with: PlayerControlsViewModel(songName: dataSource?.songName ?? "", subTitle: dataSource?.subtitle ?? ""))
    }
    
    private func configureBarButtons(){
        navigationItem.leftBarButtonItem=UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
    }
    
    @objc private func didTapClose(){
        dismiss(animated: true,completion: nil)
        
    }
    @objc private func didTapAction(){
        //Actions
    }
    
}

extension PlayerViewController:PlayerControlsViewDelegate{
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)
    }
    
    func playerControlsViewDidTapPlayPauseButton(_ playerControlView: PlayerControlsView) {
        
        delegate?.didTapPlayPause()
    }
    
    func playerControlsViewDidTapNextButton(_ playerControlView: PlayerControlsView) {
        delegate?.didTapForward()
    }
    
    func playerControlsViewDidTapBackButton(_ playerControlView: PlayerControlsView) {
        delegate?.didTapBackwards()
    }
    
  
    
    
}
