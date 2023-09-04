//
//  AlertModel.swift
//  Guess The Flag
//
//  Created by Maciej Helmecki on 05/09/2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let actionTitle: String
    let action: (() -> Void)?
    
    static var empty: AlertModel {
        AlertModel(title: "", message: "", actionTitle: "", action: nil)
    }
}
