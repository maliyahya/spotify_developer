//
//  SearchViewController.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 28.01.2024.
//

import UIKit
import SafariServices

class SearchViewController: UIViewController {
    
    private var categories=[CategoryItem]()
    private var colors:[UIColor]=[
        .systemPink,
        .systemBlue,
        .systemPurple,
        .systemOrange,
        .systemGreen,
        .systemRed,
        .systemYellow,
        .darkGray,
        .systemTeal
    ]
    private var collectionView:UICollectionView=UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _ , _ -> NSCollectionLayoutSection? in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets=NSDirectionalEdgeInsets(top: 2, leading: 7, bottom: 2, trailing: 7)
        let group=NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(180)), subitem:item ,count: 2)
        group.contentInsets=NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        return NSCollectionLayoutSection(group: group)
    }))
    
    
    let searchController:UISearchController={
        let vc=UISearchController(searchResultsController: SearchResultsViewController())
        vc.searchBar.placeholder="Song,Artists,Albums"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        APICaller.shared.getCategories { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self?.categories = success.categories.items
                    self?.collectionView.reloadData()
                case .failure(let failure):
                    break
                }
            }
           
        }
        searchController.searchBar.delegate=self
        navigationItem.searchController = searchController
        view.addSubview(collectionView)
        collectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        collectionView.delegate=self
        collectionView.dataSource=self
        collectionView.backgroundColor = .systemBackground
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame=view.bounds
    }
}

extension SearchViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultsController=searchController.searchResultsController as? SearchResultsViewController,
                let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        resultsController.delegate=self
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    resultsController.update(with: success)
                case .failure(let failure):
                    break
                }
            }
        }
    }
}

extension SearchViewController:SearchResultViewControllerDelegate{
    func didTapResult(_ result: SearchResult) {
        switch result {
        case .artist(let model):
            guard let url=URL(string: model.external_urls["spotify"] ?? "")else { return }
            let vc=SFSafariViewController(url: url)
            present(vc,animated:true)
        case .album(let model):
            let vc=AlbumViewController(album: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .track(let model):
            return
        case .playlist(let model):
            let vc=PlaylistViewController(playList: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

extension SearchViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as? GenreCollectionViewCell else { return UICollectionViewCell()}
        cell.backgroundColor = colors.randomElement()
        let model=categories[indexPath.row]
        cell.configure(title: model.name,genreLogo:model.icons.first?.url ?? "" )
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category=categories[indexPath.row]
        let vc=CategoryDetailViewController(category: category)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
