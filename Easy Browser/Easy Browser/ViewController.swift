//
//  ViewController.swift
//  Easy Browser
//
//  Created by Maciej Helmecki on 26/06/2023.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    // MARK: - Properties
    
    private var webView: WKWebView!
    
    // MARK: - Lifecycle
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))

        load(stringUrl: "https://www.google.com")
    }
    
    // MARK: - Methods
    @objc private func openTapped() {
        let alert = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
        alert.addAction(UIAlertAction(title: "google.com", style: .default, handler: openPage))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        
        present(alert, animated: true)
    }
    
    private func openPage(_ action: UIAlertAction) {
        let stringUrl = "https://\(action.title!)"
        
        load(stringUrl: stringUrl)
    }
    
    private func load(stringUrl: String) {
        let url = URL(string: stringUrl)!
        
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
}
