//
//  LibraryPlaylistViewController.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 5.02.2024.
//

import UIKit

class LibraryPlaylistViewController: UIViewController {
    
    var playlists=[PlayList]()
    var actionLabelView=ActionLabelView()
    public var selectionHandler:((PlayList)->Void)?
    
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

        if selectionHandler != nil {
            navigationItem.leftBarButtonItem=UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        }
    }
    
    @objc private func didTapClose(){
        dismiss(animated: true,completion: nil)
    }
    
 
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        actionLabelView.frame=CGRect(x:120, y:150 , width: 160, height: 150)
        tableView.frame=view.bounds
            }
    private func fetchData(){
        APICaller.shared.getCurrentUserPlaylists { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self?.playlists=success
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
        actionLabelView.configure(with: ActionLabelViewViewModel(text: "You don't have any playlist yet", actionTitle: "Create"))
    }
    private func updateUI(){
        if playlists.isEmpty{
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

extension LibraryPlaylistViewController:ActionLabelViewDelegate{
    func actionLabelViewDidTapButton() {
      showCreatePlayListAlert()
        
    }
}

extension LibraryPlaylistViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.identifier, for: indexPath) as?
                SearchResultDefaultTableViewCell else { return UITableViewCell()}
        let model=playlists[indexPath.row]
        cell.configure(model: DefaultTableModel(title: model.name, subtitle: model.owner.display_name, imageURL: model.images.first?.url ?? ""))
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model=playlists[indexPath.row]
        guard selectionHandler == nil else {
            selectionHandler?(model)
            dismiss(animated: true,completion: nil)
            return
        }
        let vc=PlaylistViewController(playList: model)
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.isOwner=true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
