import UIKit

class HomeViewController: UICollectionViewController {
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - Methods
    
    private func setupView() {
        collectionView.backgroundColor = .darkGray
        collectionView.register(PersonCell.self, forCellWithReuseIdentifier: "Person")
    }
}

extension HomeViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError()
        }
        
        cell.titleLabel.text = "Hello World!"
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140.0, height: 180.0)
    }
}
