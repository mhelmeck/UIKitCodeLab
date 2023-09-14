//
//  PetitionsViewModel.swift
//  We The People
//
//  Created by Maciej Helmecki on 14/09/2023.
//

import Combine
import Foundation

protocol PetitionsViewModel {
    var petitionsPublisher: Published<[String]>.Publisher { get }
}
