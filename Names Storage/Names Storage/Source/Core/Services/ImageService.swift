import Foundation
import UIKit

class ImageService {
    // MARK: - Init
    
    var people = [Person]()
    
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
