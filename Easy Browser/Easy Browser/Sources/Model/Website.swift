//
//  Website.swift
//  Easy Browser
//
//  Created by Maciej Helmecki on 05/09/2023.
//

import Foundation

struct Website: Decodable {
    let title: String
    let urlString: String
    
    enum CodingKeys: String, CodingKey {
        case title = "name"
        case urlString = "url"
    }
}
