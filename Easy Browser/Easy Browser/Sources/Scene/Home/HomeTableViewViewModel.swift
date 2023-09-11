//
//  HomeTableViewViewModel.swift
//  Easy Browser
//
//  Created by Maciej Helmecki on 11/09/2023.
//

import Combine
import Foundation

class HomeTableViewViewModel {
    // MARK: - Properties
    
    @Published private(set) var websites = [Website]()
    
    // MARK: - Init
    init() {
        loadData()
    }
    
    
    // MARK: - Methods
    
    private func loadData() {
        guard let path = Bundle.main.path(forResource: "Websites", ofType: "json") else {
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let result = try decoder.decode(WebsiteList.self, from: jsonData)
            
            websites = result.websites
        } catch {}
    }
}
