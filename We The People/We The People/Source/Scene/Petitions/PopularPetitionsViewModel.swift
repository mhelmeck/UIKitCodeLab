import Combine
import Foundation

class PopularPetitionsViewModel: PetitionsViewModel {
    // MARK: - Properties
        
    var petitionsPublisher: Published<[Petition]>.Publisher { $petitions }
    
    @Published private var petitions: [Petition] = []
    
    // MARK: - Init
    
    init() {
        
    }
    
    // MARK: - Methods
}

