//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 28.01.2024.
//

import UIKit

class WelcomeViewController: UIViewController {
    private let signInButton:UIButton={
       let button=UIButton()
        button.setTitle("Sign in with Spotify", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints=false
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.backgroundColor = .systemGreen
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        configureConstraints()
    }
    private func configureConstraints(){
        NSLayoutConstraint.activate([
            signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signInButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        )
    }
    @objc func  didTapSignIn(){
        let vc = AuthViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completionHandler = { [weak self]
            success in
            DispatchQueue.main.async {
                self?.handleSignIn(success:success)
            }
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
    private func handleSignIn(success:Bool){
        guard success else {
            let alert=UIAlertController(title: "Oops", message: "Something went wrong when signing in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel,handler: nil))
            present(alert,animated: true)
            return
        }
        let mainAppTabBarVC=TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
    }


}
