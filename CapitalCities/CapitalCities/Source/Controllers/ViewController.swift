import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
    // MARK: - Properties

    @IBOutlet weak var mapView: MKMapView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    // MARK: - Methods

    private func setupView() {
        createCapitals().forEach(mapView.addAnnotation)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeMapType))
    }

    private func createCapitals() -> [Capital] {
        return [
            Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics."),
            Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago."),
            Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light."),
            Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it."),
            Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        ]
    }

    @objc private func changeMapType() {
        let ac = UIAlertController(title: "Choose map style", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Satelite", style: .default, handler: { [weak self] _ in
            self?.mapView.mapType = .satellite
        }))
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: { [weak self] _ in
            self?.mapView.mapType = .hybrid
        }))
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: { [weak self] _ in
            self?.mapView.mapType = .standard
        }))

        present(ac, animated: true)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { 
            return nil
        }

        let identifier = "Capital"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true

            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }

        annotationView?.markerTintColor = .systemGreen
        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else {
            return
        }

        let webVC = WebViewController()
        webVC.capital = capital

        navigationController?.pushViewController(webVC, animated: true)
    }
}

