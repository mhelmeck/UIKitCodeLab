//
//  File.swift
//  Storm Viewer
//
//  Created by Maciej Helmecki on 05/07/2023.
//

import Combine
import Foundation

class HomeTableViewModel {
    // MARK: - Properties
    
    let homeTitle = "Storm Viewer"
    let shareTitle = "Check out this amazing app!"
    let shareURL = URL(string: "https://www.hackingwithswift.com")
    
    @Published private(set) var models = [ImageModel]()
    
    // MARK: - Init
    
    init() {
        fetchItems()
    }
    
    // MARK: - Methods
    
    func imageTitle(for index: Int) -> String? {
        guard index >= 0 && index < models.count else {
            return nil
        }
        
        return models[index].title
    }
    
    func imageExtendedTitle(for index: Int) -> String? {
        guard index >= 0 && index < models.count else {
            return nil
        }
        
        let amount = models.count
        let selectedPosition = index + 1
        
        return "Picture \(selectedPosition) of \(amount)"
    }
    
    private func fetchItems() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)

        for item in items {
            if item.hasPrefix("nssl") {
                models.append(ImageModel(title: item))
            }
        }
        
        models.sort()
    }
}
