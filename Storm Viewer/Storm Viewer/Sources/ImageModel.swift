//
//  CellModel.swift
//  Storm Viewer
//
//  Created by Maciej Helmecki on 05/07/2023.
//

import Foundation

struct ImageModel {
    let title: String
}

extension ImageModel: Comparable {
    static func < (lhs: ImageModel, rhs: ImageModel) -> Bool {
        lhs.title < rhs.title
    }
}
