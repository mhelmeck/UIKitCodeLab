//
//  HomeViewModel.swift
//  Word Scramble
//
//  Created by Maciej Helmecki on 05/07/2023.
//

import Combine
import Foundation

class HomeViewModel {
    // MARK: - Properties

    let reloadDataSubject = PassthroughSubject<Void, Never>()
    
    @Published var title = String()
    private (set) var usedWords = [String]()
    private var allWords = [String]()
    
    // MARK: - Init
    
    init() {
        loadData()
        startGame()
    }
    
    // MARK: - Methods
    
    func removeUsedWords() {
        usedWords.removeAll(keepingCapacity: true)
    }
    
    func usedWord(for index: Int) -> String? {
        guard index >= 0 && index < usedWords.count else {
            return nil
        }
        
        return usedWords[index]
    }
    
    private func loadData() {
        guard let url = Bundle.main.url(forResource: "words", withExtension: "txt"),
             let words = try? String(contentsOf: url) else {
            return
        }
        
        allWords = words.components(separatedBy: "\n")
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
    }
    
    private func startGame() {
        title = allWords.randomElement()?.capitalized ?? ""
        removeUsedWords()
        reloadDataSubject.send()
    }
}
