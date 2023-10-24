import UIKit
import WebKit

class WebViewController: UIViewController {
    // MARK: - Properties

    var webView: WKWebView!
    var capital: Capital!

    // MARK: - Lifecycle

    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadPage()
    }

    // MARK: - Methods

    private func loadPage() {

        guard let city = capital.title,
              let url = URL(string: "https://en.wikipedia.org/wiki/\(city)"),
              UIApplication.shared.canOpenURL(url) else {
            presentErrorAlert()
            return
        }

        webView.load(URLRequest(url: url))
    }

    private func presentErrorAlert() {
        let placeName = capital.title
        let placeInfo = capital.info

        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        })
        present(ac, animated: true)
    }
}
