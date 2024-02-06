//
//  ProfileViewController.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 29.01.2024.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    private let tableView:UITableView={
       let tableView=UITableView()
        tableView.isHidden=true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var models=[String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title="Profile"
        view.addSubview(tableView)
        tableView.frame=view.bounds
        tableView.delegate=self
        tableView.dataSource=self
        fetchProfile()
        
    }
    private func fetchProfile(){
        APICaller.shared.getCurrentUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success( let model):
                    self?.updateUI(with:model)
                case .failure(let failure):
                    print(failure.localizedDescription)
                    self?.failedToGetProfile()
                }
            }
        }
    }
    private func updateUI(with model:UserModel){
        tableView.isHidden=false
        models.append("Display Name : \(model.display_name)")
        models.append("Country : \(model.country)")
        models.append("Subscribe Type : \(model.product)")
        models.append("Followers : \(model.followers.total)")

        createTableHeader(with: model.images.first?.url)
        tableView.reloadData()
    }
    private func createTableHeader(with string:String?){
        guard let urlString=string,let url=URL(string: urlString) else { return }
        let headerView=UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/1.5))
        let imageView=UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        headerView.addSubview(imageView)
        imageView.center=headerView.center
        imageView.contentMode = .scaleAspectFit
        imageView.sd_setImage(with: url,completed: nil)
        imageView.layer.masksToBounds=true
        imageView.layer.cornerRadius=headerView.height/4
        tableView.tableHeaderView=headerView

    }
    private func failedToGetProfile(){
        let label=UILabel(frame: .zero)
        label.text="Failed to load profile"
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center=view.center
    }
}

extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return  models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text=models[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    
}
