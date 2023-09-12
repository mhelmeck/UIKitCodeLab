//
//  AlertModel.swift
//  Word Scramble
//
//  Created by Maciej Helmecki on 11/09/2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    
    static var empty: AlertModel {
        AlertModel(title: "", message: "")
    }
}
