//
//  AuthViewController.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 28.01.2024.
//

import UIKit
import WebKit

class AuthViewController: UIViewController {
    private let webView:WKWebView={
     let prefs=WKWebpagePreferences()
        prefs.allowsContentJavaScript=true
    let config=WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView=WKWebView(frame: .zero,configuration: config)
        return webView
    }()
    
    public var completionHandler:((Bool)->Void)?
        
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title="Sign In"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate=self
        view.addSubview(webView)
        configureConstraints()
        guard let url = AuthManager.shared.signInURL else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    private func configureConstraints(){
        webView.frame = view.bounds
        }
}
extension AuthViewController:WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code" })?.value else{
            return
        }
        
        AuthManager.shared.exchangeCodeForToken(code: code) { [weak self]  success in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.completionHandler?(success)
            }
        }
    }
    
}
