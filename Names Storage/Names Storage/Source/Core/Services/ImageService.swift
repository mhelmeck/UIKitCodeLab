import Foundation
import UIKit

class ImageService {
    // MARK: - Properties
    
    var people = [Person]()
    
    private let defaults = UserDefaults.standard
    
    // MARK: - Init
    
    init() {}
    
    // MARK: - Methods
    
    func save(_ image: UIImage) {
        let imageName = UUID().uuidString
        let imageUrl = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imageUrl)
        }
        
        let person = Person(name: "Unknown", imageName: imageName)
        people.append(person)
    }
    
    func loadFomrDisc() {
        let decoder = JSONDecoder()
        guard let data = defaults.object(forKey: "people") as? Data else {
            return
        }
        
        guard let decodedPeople = try? decoder.decode([Person].self, from: data) else {
            return
        }
        
        people = decodedPeople
    }
    
    func saveToDisc() {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(people) else { return }
        
        defaults.set(data, forKey: "people")
    }
    
    func read(imageName: String) -> UIImage {
        let url = getDocumentsDirectory().appendingPathComponent(imageName)
        guard let image = UIImage(contentsOfFile: url.path) else {
            fatalError()
        }
        
        return image
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
}
