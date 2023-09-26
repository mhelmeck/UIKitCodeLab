import Foundation

class WordsStorage {
    // MARK: - Properties
    
    private let defaults = UserDefaults.standard
    private var storage: [String: [String]]
    
    // MARK: - Init
    init() {
        let anyStorage = defaults.dictionary(forKey: "storage") ?? [:]
        
        storage = anyStorage as! [String: [String]]
    }
    
    // MARK: - Methods
    
    func readWords(for title: String) -> [String] {
        return wordsFor(title)
    }
    
    func write(_ word: String, for title: String) {
        let newWords = wordsFor(title) + [word]
        storage[title] = newWords
        
        defaults.setValue(storage, forKey: "storage")
    }
    
    private func wordsFor(_ title: String) -> [String] {
        return storage[title] ?? []
    }
}
