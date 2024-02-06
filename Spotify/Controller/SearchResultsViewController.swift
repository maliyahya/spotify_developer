//
//  SeachResultsViewController.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 1.02.2024.
//

import UIKit

struct SearchSection{
    let title:String
    let results:[SearchResult]
}

protocol SearchResultViewControllerDelegate:AnyObject{
    func didTapResult(_ result:SearchResult)
}


class SearchResultsViewController: UIViewController {
    
    weak var delegate:SearchResultViewControllerDelegate?
    
    private var tableView:UITableView={
        let table=UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .systemBackground
        table.isHidden=true
        return table
    }()
    private var sections:[SearchSection] = [ ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate=self
        tableView.dataSource=self
        tableView.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame=view.bounds
    }
    
    func update(with results:[SearchResult]){
        let artists=results.filter({
            switch $0{
            case .artist:
                return true
            default:
                return false
            }
        })
        let album=results.filter({
            switch $0{
            case .album:
                return true
            default:
                return false
            }
        })
        let track=results.filter({
            switch $0{
            case .track:
                return true
            default:
                return false
            }
        })
        let playlist=results.filter({
            switch $0{
            case .playlist:
                return true
            default:
                return false
            }
        })
        self.sections=[
            SearchSection(title: "Artists", results: artists),
            SearchSection(title: "Tracks", results: track),
            SearchSection(title: "Playlists", results: playlist),
            SearchSection(title: "Albums", results: album)

        ]
        tableView.reloadData()
        tableView.isHidden = results.isEmpty
    }
}


extension SearchResultsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]
        switch result {
        case .artist(model: let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.identifier) as? SearchResultDefaultTableViewCell else { return UITableViewCell() }
            let configureModel = DefaultTableModel(title: model.name, subtitle: "", imageURL: model.images?.first?.url ?? "")
            cell.configure(model: configureModel)
            return cell
        case .album(model: let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.identifier) as? SearchResultDefaultTableViewCell else { return UITableViewCell() }
            let configureModel=DefaultTableModel(title: model.name, subtitle: model.artists.first?.name ?? "", imageURL: model.images.first?.url ?? "")
            cell.configure(model: configureModel)
            return cell

        case .track(model: let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.identifier) as? SearchResultDefaultTableViewCell else { return UITableViewCell() }
            let configureModel=DefaultTableModel(title: model.name, subtitle: model.artists.first?.name ?? "", imageURL: model.album.images.first?.url ?? "")
            cell.configure(model: configureModel)
            return cell

        case .playlist(model: let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.identifier) as? SearchResultDefaultTableViewCell else { return UITableViewCell() }
            let configureModel=DefaultTableModel(title: model.name, subtitle: model.owner.display_name , imageURL: model.images.first?.url ?? "")
            cell.configure(model: configureModel)
            return cell
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result=sections[indexPath.section].results[indexPath.row]
        delegate?.didTapResult(result)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    
}
