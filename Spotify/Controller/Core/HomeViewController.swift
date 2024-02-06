//
//  HomeViewController.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 28.01.2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var newAlbums:[Album]=[]
    private var playLists:[PlayList]=[]
    private var tracks:[AudioTrack]=[]
    private var collectionView:UICollectionView=UICollectionView(
        frame:.zero,
        collectionViewLayout: UICollectionViewCompositionalLayout
        {
            sectionIndex , _ -> NSCollectionLayoutSection? in
            return HomeViewController.createSectionLayout(section:sectionIndex)
        }
    )
    enum BrowseSectionType {
    case newReleases(viewModels:[NewReleasesCellModel]) // 0
    case featuredPlaylists(viewModels:[FeaturedPlaylistCellModel]) // 1
    case recommendedTracks(viewModels:[RecommendedTrackCellModel]) // 2
        var title:String{
            switch self{
            case .newReleases:
                return "New Released Albums"
            case .featuredPlaylists:
                return "Featured Playlists"
            case .recommendedTracks:
                return "Recommended"
            }
        }
        
    }
    private var sections=[BrowseSectionType]()
    private static func createSectionLayout(section:Int)->NSCollectionLayoutSection{
        let supplementaryViews=[NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
        switch section{
        case 0:
            //Item
            let item=NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)))
            item.contentInsets=NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            //Group
            let verticalGroup=NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                widthDimension:.fractionalWidth(1.0),
                heightDimension:.absolute(240)),
                subitem:item,
                count:2)
            let horizontalGroup=NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
                widthDimension:.fractionalWidth(1.0),
                heightDimension:.absolute(240)),
                subitem:verticalGroup,
                count:1)
            //Section
            let section=NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems=supplementaryViews
            return section
        
        case 1:
            //Item
            let item=NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)))
            item.contentInsets=NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            //Group
            let verticalGroup=NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                widthDimension:.fractionalWidth(0.5),
                heightDimension:.absolute(200)),
                subitem:item,
                count:1)
            let horizontalGroup=NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
                widthDimension:.fractionalWidth(0.5),
                heightDimension:.absolute(200)),
                subitem:verticalGroup,
                count:1)
            //Section
            let section=NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems=supplementaryViews

            return section
        case 2:
            //Item
            let item=NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)))
            item.contentInsets=NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            //Group
            let verticalGroup=NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                widthDimension:.fractionalWidth(1.0),
                heightDimension:.absolute(240)),
                subitem:item,
                count:3)
            let horizontalGroup=NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
                widthDimension:.fractionalWidth(1.0),
                heightDimension:.absolute(240)),
                subitem:verticalGroup,
                count:1)
            //Section
            let section=NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems=supplementaryViews

            return section
        default:
            //Item
            let item=NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)))
            item.contentInsets=NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            //Group
            let group=NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
                widthDimension:.fractionalWidth(0.9),
                heightDimension:.absolute(360)),
                subitem:item,
                count:1)
            //Section
            let section=NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems=supplementaryViews

            return section
        }
    }
    private let spinner:UIActivityIndicatorView={
       let spinner=UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped=true
        spinner.translatesAutoresizingMaskIntoConstraints=false
        return spinner
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title="Home"
        view.backgroundColor = .systemBackground
        view.addSubview(spinner)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
        configureCollectionView()
        fetchData()
        let gesture=UILongPressGestureRecognizer(target: self, action: #selector(didLongPress))
        collectionView.isUserInteractionEnabled=true
        collectionView.addGestureRecognizer(gesture)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame=view.bounds
    }
    @objc func didLongPress(_ gesture:UILongPressGestureRecognizer){
        guard gesture.state == .began else {
            return
        }
        let touchPoint=gesture.location(in: collectionView)
        guard let indexPath=collectionView.indexPathForItem(at: touchPoint),indexPath.section==2
        else {
            return
        }
        print(indexPath.section)

        let model=tracks[indexPath.row]
        let actionSheet=UIAlertController(title: model.name, message: "Would you like to add this to a playlist", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self]_ in
            DispatchQueue.main.async {
                let vc=LibraryPlaylistViewController()
                vc.selectionHandler = { playlist in
                    APICaller.shared.addTrackToPlayList(track: model, playlist: playlist) { success in
                        if success{
                       
                        }
                        else
                        {
                            
                        }
                    }
                }
                vc.title = "Select Playlist"
                self?.present(UINavigationController(rootViewController: vc),animated: true,completion: nil)
            }
           
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet,animated: true)
    }
    @objc private func didTapSettings(){
        let vc=SettingsViewController()
        vc.title="Profile"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.dataSource=self
        collectionView.delegate=self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(NewReleasesCollectionViewCell.self, forCellWithReuseIdentifier: NewReleasesCollectionViewCell.identifier)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        collectionView.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)


    }
    private func fetchData(){
        let group=DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        var newReleases:NewReleasesModel?
        var featuredPlaylist:FeaturedPlaylistsResponse?
        var recommendations:RecommendationResponse?
          APICaller.shared.getNewReleases { result in
              defer{
                  group.leave()
              }
         switch result {
         case .success(let success):
             newReleases=success
         case .failure(_):
             break
         }
     }
        APICaller.shared.getFeaturedPlaylist { result in
         defer{
             group.leave()
         }
         switch result {
         case .success(let success):
             featuredPlaylist=success
         case .failure(_):
             break
         }
     }
     APICaller.shared.getRecommendedGenres { result in
                switch result {
                case .success(let model):
                    let genres=model.genres
                    var seeds = Set<String>()
                    while seeds.count < 5 {
                        if let random=genres.randomElement(){
                            seeds.insert(random)
                        }
                    }
                    APICaller.shared.getRecommendations(genres: seeds) { recommendedResult in
                        defer{
                            group.leave()
                        }
                        switch recommendedResult {
                        case .success(let model):
                            recommendations=model
                        case .failure(_):
                            break
                        }
                    }
                case .failure(let failure):
                    print(failure)
                }
            }
        group.notify(queue: .main){
            guard let releases=newReleases?.albums.items,
                  let playlists=featuredPlaylist?.playlists.items,
                  let track=recommendations?.tracks else {
                return
            }
            self.configureModel(newAlbums: releases, playlists: playlists, tracks: track)
        }
        }
     func configureModel(newAlbums:[Album],playlists:[PlayList],tracks:[AudioTrack]){
         self.newAlbums=newAlbums
         self.playLists=playlists
         self.tracks=tracks
        self.sections.append(.newReleases(viewModels: newAlbums.compactMap({ return NewReleasesCellModel(name: $0.name, artworkURL: URL(string:$0.images.first?.url ?? ""), numberOfTracks: $0.total_tracks, artistName: $0.artists.first?.name ?? "")
            
        })))
         self.sections.append(.featuredPlaylists(viewModels: playlists.compactMap({ return FeaturedPlaylistCellModel(name: $0.name , artworkURL: URL(string: $0.images.first?.url  ?? ""), creatorName: $0.owner.display_name )
         })))
         self.sections.append(.recommendedTracks(viewModels:tracks.compactMap({
             return RecommendedTrackCellModel(name: $0.name, artistName: $0.artists.first?.name ?? "" , artworkURL: URL(string: $0.album?.images.first?.url ?? "") )
             
         })))
         collectionView.reloadData()
    }
}
extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       let type=sections[section]
        switch type {
        case .newReleases(let viewModels):
            return viewModels.count
        case .featuredPlaylists(let viewModels):
            return viewModels.count
        case .recommendedTracks(let viewModels):
            return viewModels.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type=sections[indexPath.section]
         switch type {
         case .newReleases(let viewModels):
             guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleasesCollectionViewCell.identifier, for: indexPath)
             as? NewReleasesCollectionViewCell
             else { return UICollectionViewCell()
             }
             let viewModel=viewModels[indexPath.row]
             cell.configure(with: viewModel)
             return cell
             
         case .featuredPlaylists(let viewModels):
             guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath)
             as? FeaturedPlaylistCollectionViewCell
             else { return UICollectionViewCell()
             }
             let viewModel=viewModels[indexPath.row]

             cell.configure(with: viewModel)
             return cell
             
         case .recommendedTracks(let viewModels):
             guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath)
             as? RecommendedTrackCollectionViewCell
             else { return UICollectionViewCell()
             }
             let viewModel=viewModels[indexPath.row]
             cell.configure(with: viewModel)
             cell.backgroundColor = .systemMint

             return cell
         }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section=sections[indexPath.section]
        switch section{
        case .newReleases(viewModels: _):
            let album=newAlbums[indexPath.row]
            let vc=AlbumViewController(album: album)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .featuredPlaylists(viewModels: _):
            let playlist=playLists[indexPath.row]
            let vc=PlaylistViewController(playList:playlist)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .recommendedTracks(viewModels: _):
            break
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard  let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier, for: indexPath) as? TitleHeaderCollectionReusableView,kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView()}
       let section = indexPath.section
        let model=sections[section].title
        header.configure(with: model)
        return header
    }
    
    
    
}
