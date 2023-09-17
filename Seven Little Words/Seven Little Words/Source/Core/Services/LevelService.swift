import Foundation

class LevelService {
    // MARK: - Methods
    func load(level: Int, completion: @escaping (Level) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let url = Bundle.main.url(forResource: "level\(level)", withExtension: "txt"),
                  let content = try? String(contentsOf: url) else {
                return
            }
            
            var solutions = [String]()
            var clueString = ""
            var solutionString = ""
            var letterBits = [String]()
            
            var lines = content.components(separatedBy: "\n")
            lines.shuffle()
            for (index, line) in lines.enumerated() {
                let parts = line.components(separatedBy: ": ")
                let answer = parts[0]
                let clue = parts[1]
                
                clueString += "\(index + 1). \(clue)\n"
                
                let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                solutionString += "\(solutionWord.count) letters\n"
                solutions.append(solutionWord)

                let bits = answer.components(separatedBy: "|")
                letterBits += bits
            }
            
            letterBits.shuffle()
            
            let level = Level(
                solutions: solutions,
                clueString: clueString.trimmingCharacters(in: .whitespacesAndNewlines),
                solutionString: solutionString.trimmingCharacters(in: .whitespacesAndNewlines),
                letterBits: letterBits
            )
            
            DispatchQueue.main.async {
                completion(level)
            }
        }
    }
}
