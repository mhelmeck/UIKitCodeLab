import Foundation

class Person: Codable {
    var name: String
    var imageName: String
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}

// MARK: - NSCoding example

//class Person: NSObject, NSCoding {
//    var name: String
//    var imageName: String
//    
//    init(name: String, imageName: String) {
//        self.name = name
//        self.imageName = imageName
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
//        imageName = aDecoder.decodeObject(forKey: "imageName") as? String ?? ""
//    }
//
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(name, forKey: "name")
//        aCoder.encode(imageName, forKey: "imageName")
//    }
//}
//
//func loadFomrDisc() {
//    guard let data = defaults.object(forKey: "people") as? Data else { return }
//    
//    if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Person] {
//        people = decodedPeople
//    }
//}
//
//func saveToDisc() {
//    guard let data = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) else { return }
//    
//    defaults.set(data, forKey: "people")
//}
