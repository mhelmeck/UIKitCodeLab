//
//  HomeViewModel.swift
//  Word Scramble
//
//  Created by Maciej Helmecki on 05/07/2023.
//

import Combine
import Foundation
import UIKit

class HomeViewModel {
    // MARK: - Properties
    
    let reloadDataSubject = PassthroughSubject<Void, Never>()
    let wordsStorage: WordsStorage
    
    @Published var title = String()
    @Published var alertModel = AlertModel.empty
    private (set) var usedWords = [String]()
    private var allWords = [String]()
    
    // MARK: - Init
    
    init(wordsStorage: WordsStorage) {
        self.wordsStorage = wordsStorage
        
        loadData()
        startGame()
    }
    
    // MARK: - Methods
    func startGame() {
        title = allWords.randomElement()?.capitalized ?? ""
//        usedWords.removeAll(keepingCapacity: true)
        usedWords = wordsStorage.readWords(for: title)
        
        reloadDataSubject.send()
    }
    
    func submit(_ answer: String, completion: (IndexPath) -> Void) {
        let answer = answer.lowercased()
        
        guard isPossible(word: answer) else {
            alertModel = AlertModel(title: "Word not recognised", message: "You can't just make them up, you know!")
            return
        }
        
        guard isOriginal(word: answer) else {
            alertModel = AlertModel(title: "Word used already", message: "Be more original!")
            return
        }
        
        guard isReal(word: answer) else {
            alertModel = AlertModel(title: "Word not possible", message: "You can't spell that word from \(title)")
            return
        }

        usedWords.insert(answer, at: 0)
        wordsStorage.write(answer, for: title)
        completion(IndexPath(row: 0, section: 0))
    }
        
    func usedWord(for index: Int) -> String? {
        guard index >= 0 && index < usedWords.count else {
            return nil
        }
        
        return usedWords[index]
    }
}

private extension HomeViewModel {
    func loadData() {
        guard let url = Bundle.main.url(forResource: "words", withExtension: "txt"),
             let words = try? String(contentsOf: url) else {
            return
        }
        
        allWords = words.components(separatedBy: "\n")
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
    }
    
    func isPossible(word: String) -> Bool {
        var title = title.lowercased()
        
        for letter in word {
            if let position = title.firstIndex(of: letter) {
                title.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        guard word != title.lowercased() else {
            return false
        }
        
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        guard word.count >= 3 else {
            return false
        }
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(
            in: word,
            range: range,
            startingAt: 0,
            wrap: false,
            language: "en"
        )
        
        return misspelledRange.location == NSNotFound
    }
}
