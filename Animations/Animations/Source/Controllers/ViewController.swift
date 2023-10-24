import UIKit

class ViewController: UIViewController {
    // MARK: - Properties
    
    var imageView: UIImageView!
    var currentAnimation = 0

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createImageView()
    }

    // MARK: - Methods

    private func createImageView() {
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: view.bounds.width / 2.0, y: view.bounds.height / 2.0)
        view.addSubview(imageView)
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        sender.isHidden = true

        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 5,
            options: [], 
            animations: {
                self.animate()
            }) { finished in
                sender.isHidden = false
            }

        changeCurrentAnimation()
    }

    private func changeCurrentAnimation() {
        currentAnimation += 1

        if currentAnimation > 7 {
            currentAnimation = 0
        }
    }

    private func animate() {
        switch currentAnimation {
        case 0:
            imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
        case 1:
            imageView.transform = .identity
        case 2:
            imageView.transform = CGAffineTransform(translationX: -256, y: -256)
        case 3:
            imageView.transform = .identity
        case 4:
            imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        case 5:
            imageView.transform = .identity
        case 6:
            imageView.alpha = 0.1
            imageView.backgroundColor = .green
        case 7:
            imageView.alpha = 1
            imageView.backgroundColor = .clear
        default:
            break
        }
    }
}

