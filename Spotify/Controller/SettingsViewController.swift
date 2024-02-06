//
//  SettingsViewController.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 29.01.2024.
//

import UIKit

class SettingsViewController: UIViewController {
    private let tableView:UITableView={
        let tableView=UITableView(frame: .zero,style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    private var sections=[Section]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title="Settings"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        configureModels()
        tableView.frame = view.bounds
        tableView.dataSource=self
        tableView.delegate=self

    }
    private func configureModels(){
        sections.append(Section(title: "Profile", options: [Option(title: "View Your Profile", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.viewProfile()
            }
        })]))
        sections.append(Section(title: "Account", options: [Option(title: "Sign Out", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.signOutTapped()
            }
        })]))
    }
    private func signOutTapped(){
        let alert=UIAlertController(title: "Sign Out", message: "Are you sure ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            AuthManager.shared.signOut { success in
                DispatchQueue.main.async {
                    if success {
                        let navVC=UINavigationController(rootViewController: WelcomeViewController())
                        navVC.navigationBar.prefersLargeTitles=true
                        navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
                        navVC.modalPresentationStyle = .fullScreen
                        self.present(navVC,animated: true,completion:{
                            self.navigationController?.popToRootViewController(animated: false)
                        })
                    }
                    else{
                        
                    }
                }
            }
            
        }))
        present(alert,animated: true)
    }
    private func viewProfile(){
        let vc=ProfileViewController()
        vc.title="Profile"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    private func configureConstraints(){
        NSLayoutConstraint.activate([
            ])
    }
}
extension SettingsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text=model.title
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = sections[section]
        return model.title
    }
    
}
