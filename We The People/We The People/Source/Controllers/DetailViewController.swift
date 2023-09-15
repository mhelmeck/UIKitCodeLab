import UIKit
import WebKit

class DetailViewController: UIViewController {
    // MARK: - Properties
    
    var webView: WKWebView!
    var petition: Petition?

    // MARK: - Lifecycle
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    // MARK: - Methods
    
    private func setupView() {
        guard let petition = petition else { return }

        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        \(petition.body)
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
}
