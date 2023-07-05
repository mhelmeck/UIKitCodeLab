//
//  DetailsViewModel.swift
//  Storm Viewer
//
//  Created by Maciej Helmecki on 05/07/2023.
//

import Foundation

class DetailsViewModel {
    // MARK: - Properties
    
    let selectedModelTitle: String?
    let detailsTitle: String?
    
    // MARK: - Init
    init(selectedModelTitle: String?, detailsTitle: String?) {
        self.selectedModelTitle = selectedModelTitle
        self.detailsTitle = detailsTitle
    }
    
    
    // MARK: - Methods
}
