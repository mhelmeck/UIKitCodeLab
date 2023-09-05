//
//  WebsiteViewModel.swift
//  Easy Browser
//
//  Created by Maciej Helmecki on 05/09/2023.
//

import Foundation

class WebsiteViewModel {
    // MARK: - Properties
    
    var stringUrl: String {
        websites[selectedIndex].urlString
    }
    
    let websites: [Website]
    private let selectedIndex: Int
    
    // MARK: - Init
    init(websites: [Website], selectedIndex: Int) {
        self.websites = websites
        self.selectedIndex = selectedIndex
    }
    
    // MARK: - Methods
}
