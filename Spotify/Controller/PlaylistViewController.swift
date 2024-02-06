//
//  AlbumViewController.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 31.01.2024.
//

import UIKit

class PlaylistViewController: UIViewController {
    
    let playList:PlayList
    private var viewModel=[RecommendedTrackCellModel]()
    private var tracks=[AudioTrack]()
    private let collectionView:UICollectionView=UICollectionView(frame: .zero,collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ ->NSCollectionLayoutSection in
        //Item
        let item=NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)))
        item.contentInsets=NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        //Group
        let group=NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
            widthDimension:.fractionalWidth(1.0),
            heightDimension:.absolute(80)),
            subitem:item,
            count:1)
        //Section
        let section=NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems=[
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.4)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        return section
    }))
    public var isOwner=false
    override func viewDidLoad() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        super.viewDidLoad()
        title=playList.name
        view.backgroundColor = .systemGreen
        view.addSubview(collectionView)
        collectionView.addGestureRecognizer(gesture)
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier:RecommendedTrackCollectionViewCell.identifier)
        collectionView.register(PlaylistHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        collectionView.delegate=self
        collectionView.dataSource=self
        navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        APICaller.shared.getPlaylistDetails(for: playList) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self.tracks=success.tracks.items.compactMap({$0.track})
                    self.viewModel=success.tracks.items.compactMap({
                        RecommendedTrackCellModel(name: $0.track.name, artistName: $0.track.artists.first?.name ?? "", artworkURL: URL(string: $0.track.album?.images.first?.url ?? ""))
                    })
                    self.collectionView.reloadData()
                case .failure(_):
                    return
                }
            }
        }
    }
    init(playList: PlayList) {
        self.playList=playList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame=view.bounds
    }
    
    @objc func didLongPress(_ gesture:UILongPressGestureRecognizer){
        guard gesture.state == .began else {
            return
        }
        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else {
            return
        }
        let trackToDelete = tracks[indexPath.row]
        
        let actionSheet=UIAlertController(title: trackToDelete.name, message: "Would you like to remove this from the playlist?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Remove", style: .destructive, handler:{ [weak self]_ in
            guard let strongSelf=self else { return }
            APICaller.shared.removeTrackFromPlaylist(track: trackToDelete, playlist: strongSelf.playList) { success in
                DispatchQueue.main.async {
                    if success{
                        strongSelf.tracks.remove(at: indexPath.row)
                        strongSelf.viewModel.remove(at: indexPath.row)
                        strongSelf.collectionView.reloadData()
                    }
                    else{
                        print("didnt removed")
                    }
                }
            }
            
        }))

        
        present(actionSheet,animated: true,completion: nil)
    }
    
    @objc private func didTapShare(){
        guard let url=URL(string: playList.external_urls["spotify"] ?? "") else { 
            return
        }
        
        let vc=UIActivityViewController(activityItems: ["Check out this cool playlist I found \(url)"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem=navigationItem.rightBarButtonItem
        present(vc,animated: true)
    }
    

   

}
extension PlaylistViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard  let cell=collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath)
        as? RecommendedTrackCollectionViewCell  else { return UICollectionViewCell()}
        cell.configure(with: viewModel[indexPath.row])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let track=tracks[indexPath.row]
        PlayBackPresenter.shared.startPlayback(from: self, track: track)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header=collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier,
            for: indexPath)
            as? PlaylistHeaderCollectionReusableView,
              kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView()}
        let headerViewModel=PlaylistHeaderViewModel(name: playList.name, ownerName: playList.owner.display_name, description: playList.description, artworkURL: URL(string: playList.images.first?.url ?? ""))
        header.configure(headerViewModel: headerViewModel)
        header.delegate=self
        return header
    }
    
}

extension PlaylistViewController:PlaylistHeaderCollectionReusableViewDelegate{
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
      
        PlayBackPresenter.shared.startPlayback(from: self, tracks: tracks)
    }
    
}
