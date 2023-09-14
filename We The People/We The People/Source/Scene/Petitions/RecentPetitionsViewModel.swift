import Combine
import Foundation

class RecentPetitionsViewModel: PetitionsViewModel {
    // MARK: - Properties
    
    var petitionsPublisher: Published<[String]>.Publisher { $petitions }
    
    @Published private var petitions: [String] = []
    
    // MARK: - Init
    
    init() {
        petitions = ["", "", ""]
    }
    
    // MARK: - Methods
}
