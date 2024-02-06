//
//  CategoryDetailViewController.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 2.02.2024.
//

import UIKit

class CategoryDetailViewController: UIViewController {
    
    private var collectionView:UICollectionView=UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: {
        _,_ -> NSCollectionLayoutSection in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300)))
        item.contentInsets=NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        let group=NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300)), subitem:item , count:2)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }))
    private var category:CategoryItem
    private var sections:[PlayList]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate=self
        collectionView.dataSource=self
        collectionView.register(CategorySelectionCollectionViewCell.self, forCellWithReuseIdentifier: CategorySelectionCollectionViewCell.identifier)
        APICaller.shared.getCategoryDetails(with: category) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self.sections=success
                    self.collectionView.reloadData()
                case .failure(let failure):
                    return
                }
            }
        }
    }
    
    init(category: CategoryItem) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame=view.bounds
    }
    
    
}
extension CategoryDetailViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier:CategorySelectionCollectionViewCell.identifier, for: indexPath) as?
                CategorySelectionCollectionViewCell else { return UICollectionViewCell()}
        let model=sections[indexPath.row]
        cell.configure(categoryName: model.name, coverURL: model.images.first?.url ?? "" )
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let model=sections[indexPath.row]
        let vc=PlaylistViewController(playList: model)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

}
