//
//  CellModel.swift
//  Storm Viewer
//
//  Created by Maciej Helmecki on 05/07/2023.
//

import Foundation

class ImageModel {
    let title: String
    var amount: Int
    
    init(title: String, amount: Int) {
        self.title = title
        self.amount = amount
    }
}

extension ImageModel: Comparable {
    static func == (lhs: ImageModel, rhs: ImageModel) -> Bool {
        lhs.title == rhs.title
    }
    
    static func < (lhs: ImageModel, rhs: ImageModel) -> Bool {
        lhs.title < rhs.title
    }
}
