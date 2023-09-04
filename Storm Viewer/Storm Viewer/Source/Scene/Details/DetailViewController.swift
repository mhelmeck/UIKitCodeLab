//
//  DetailViewController.swift
//  Storm Viewer
//
//  Created by Maciej Helmecki on 14/06/2023.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    // MARK: - Properties
    
    var viewModel: DetailsViewModel!
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        return view
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.hidesBarsOnTap = false
    }
    
    // MARK: - Methods
    
    private func setupView() {
        title = viewModel.detailsTitle
        view.backgroundColor = .white
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        viewModel.selectedModelTitle.map { imageView.image = UIImage(named: $0) }

        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc private func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8),
              let imageTitle = viewModel.selectedModelTitle else {
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image, "\(imageTitle)"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
