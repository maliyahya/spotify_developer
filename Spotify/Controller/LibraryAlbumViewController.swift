//
//  LibraryAlbumViewController.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 5.02.2024.
//

import UIKit


class LibraryAlbumViewController: UIViewController {
    
    var albums=[Album]()
    var actionLabelView=ActionLabelView()
    
    var tableView:UITableView={
       let table=UITableView()
        table.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifier)
        table.isHidden=true
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        actionLabelView.delegate=self
        view.backgroundColor = .systemBackground
        tableView.delegate=self
        tableView.dataSource=self
        view.addSubview(tableView)
        fetchData()
        setupActionLabelView()
        updateUI()
    }
    
 
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        actionLabelView.frame=CGRect(x:120, y:150 , width: 160, height: 150)
        tableView.frame=view.bounds
            }
    private func fetchData(){
        APICaller.shared.getCurrentUserAlbums() { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self?.albums=success
                    self?.updateUI()
                case .failure(let failure):
                    print(failure.localizedDescription)
                    self?.actionLabelView.isHidden=false

                }
            }
        }
    }

    private func setupActionLabelView(){
        view.addSubview(actionLabelView)
        actionLabelView.configure(with: ActionLabelViewViewModel(text: "You have not saved any albums yet", actionTitle: "Browse"))
    }
    private func updateUI(){
        if albums.isEmpty{
            actionLabelView.isHidden=false
            tableView.isHidden=true
        }
        else{
            tableView.reloadData()
            tableView.isHidden=false
            actionLabelView.isHidden=true
        }
    }
    
    
     func showCreatePlayListAlert(){
        let alert=UIAlertController(title: "New Playlists", message: "Enter playlist name", preferredStyle: .alert)
        alert.addTextField{ textField in
            textField.placeholder="Playlist..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: nil ))
        alert.addAction(UIAlertAction(title: "Create", style: .default,handler: {_ in
            guard let field=alert.textFields?.first,
                  let text=field.text,
                  !text.trimmingCharacters(in: .whitespaces).isEmpty else{
                      return
                  }
            APICaller.shared.createPlaylist(with: text) { success in
                        if success {
                        self.fetchData()
                    }
                    else {
                        print("Failed to create playlist")
                    }
            }
            
        } ))

        present(alert,animated: true)
        
    }
}

extension LibraryAlbumViewController:ActionLabelViewDelegate{
    func actionLabelViewDidTapButton() {
        tabBarController?.selectedIndex = 0
        
    }
}

extension LibraryAlbumViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.identifier, for: indexPath) as?
                SearchResultDefaultTableViewCell else { return UITableViewCell()}
        let model=albums[indexPath.row]
        cell.configure(model: DefaultTableModel(title: model.name , subtitle: model.artists.first?.name ?? "", imageURL:model.images.first?.url ?? ""))
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model=albums[indexPath.row]
        let vc = AlbumViewController(album:model)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
