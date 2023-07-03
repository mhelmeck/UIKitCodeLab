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
    
    var websites: [Website] = []
    var selectedIndex: Int = 0
    
    private var webView: WKWebView!
    private var progressView: UIProgressView!
    
    // MARK: - Lifecycle
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progresButton = UIBarButtonItem(customView: progressView)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        let back = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        
        toolbarItems = [refresh, progresButton, spacer, back, forward]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        load(stringUrl: websites[selectedIndex].urlString)
    }
    
    // MARK: - Methods
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    @objc private func openTapped() {
        let alert = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            alert.addAction(UIAlertAction(title: website.title, style: .default, handler: { [weak self] _ in
                let stringUrl = website.urlString
                
                self?.load(stringUrl: stringUrl)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        
        present(alert, animated: true)
    }
    
    private func load(stringUrl: String) {
        let url = URL(string: stringUrl)!
        
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        guard let host = navigationAction.request.url?.host else {
//            decisionHandler(.allow)
//            return
//        }
//
//        if websites.contains(where: { $0.urlString.contains(host) }) {
//            decisionHandler(.allow)
//        } else {
//            decisionHandler(.cancel)
//            presentAlert()
//        }
//    }
//
//    private func presentAlert() {
//        let alertVC = UIAlertController(title: "Sorry", message: "This side is blocked", preferredStyle: .alert)
//        alertVC.addAction(UIAlertAction(title: "Ok", style: .default))
//
//        present(alertVC, animated: true)
//    }
}
