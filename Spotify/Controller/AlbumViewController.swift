//
//  AlbumViewController.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 31.01.2024.
//

import UIKit

class AlbumViewController: UIViewController {
    
    private let album:Album
    private var viewModel=[AudioTrackCell]()
    private var tracks=[AudioTrack]()
    private let collectionView:UICollectionView=UICollectionView(frame: .zero,collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ ->NSCollectionLayoutSection in
            let item=NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)))
            item.contentInsets=NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            let group=NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
                widthDimension:.fractionalWidth(1.0),
                heightDimension:.absolute(50)),
                subitem:item,
                count:1)
            let section=NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems=[
                NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.4)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            ]
            return section
        }))
    override func viewDidLoad() {
        super.viewDidLoad()
        title=album.name
        view.addSubview(collectionView)
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        collectionView.delegate=self
        collectionView.dataSource=self
        collectionView.register(AudioTrackCollectionViewCell.self, forCellWithReuseIdentifier: AudioTrackCollectionViewCell.identifier)
        collectionView.register(PlaylistHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        APICaller.shared.getAlbumDetails(for: album) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self.tracks=success.tracks.items
                    self.viewModel=success.tracks.items.compactMap({
                        AudioTrackCell(name: $0.name , artistName: $0.artists.first?.name ?? "")
                    })
                 

                    self.collectionView.reloadData()
                case .failure(let error):
                    break
                }
            }
        
            
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame=view.bounds
    }
     
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func didTapShare(){
        guard let url=URL(string: album.artists.first?.external_urls["spotify"] ?? "") else {
            return
        }
        
        let vc=UIActivityViewController(activityItems: ["Check out this cool playlist I found \(url)"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem=navigationItem.rightBarButtonItem
        present(vc,animated: true)
    }
    


}

extension AlbumViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell=collectionView.dequeueReusableCell(withReuseIdentifier: AudioTrackCollectionViewCell.identifier, for: indexPath)
         as? AudioTrackCollectionViewCell  else { return UICollectionViewCell()}
         cell.configure(with: viewModel[indexPath.row])
         return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header=collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier,
            for: indexPath)
            as? PlaylistHeaderCollectionReusableView,
              kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView()}
        let headerViewModel=PlaylistHeaderViewModel(name: album.name, ownerName: album.artists.first?.name, description: "Release Date :\(String.formattedDate(string: album.release_date))", artworkURL: URL(string: album.images.first?.url ?? ""))
        header.configure(headerViewModel: headerViewModel)
        header.delegate=self
        return header
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        var track=tracks[indexPath.row]
        track.album=self.album
        PlayBackPresenter.shared.startPlayback(from: self, track: track)
    }
    
    
}


extension AlbumViewController:PlaylistHeaderCollectionReusableViewDelegate{
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        let tracksWithAlbum:[AudioTrack]=tracks.compactMap({
            var track=$0
            track.album = self.album
            return track
        })
        PlayBackPresenter.shared.startPlayback(from: self, tracks: tracksWithAlbum)
    }
    
    
}
