//
//  PersonCell.swift
//  Names Storage
//
//  Created by Maciej Helmecki on 18/09/2023.
//

import UIKit

class PersonCell: UICollectionViewCell {
    // MARK: - Properties
    
    let imageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 10, y: 10, width: 120, height: 120))
        view.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        view.layer.borderWidth = 2.0
        view.layer.cornerRadius = 4.0
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 134, width: 120, height: 40))
        label.font = UIFont(name: "MarkerFelt-Thin", size: 16.0)
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 8
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
    }
}
