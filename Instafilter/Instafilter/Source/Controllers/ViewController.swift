//
//  ViewController.swift
//  Instafilter
//
//  Created by Maciej Helmecki on 17/10/2023.
//

import CoreImage
import SnapKit
import UIKit

class ViewController: UIViewController {
    // MARK: - Properties

    private let imageWrapper: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray

        return view
    }()

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .white

        return view
    }()

    private let sliderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Intensity:"
        label.textAlignment = .right

        return label
    }()

    private let imageSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false

        return slider
    }()

    private let changeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CISepiaTone", for: .normal)
        button.contentHorizontalAlignment = .center

        return button
    }()

    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.contentHorizontalAlignment = .center

        return button
    }()

    private var currentImage: UIImage!
    private var context: CIContext!
    private var currentFilter: CIFilter!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")

        setupView()
    }

    // MARK: - Methods

    private func setupView() {
        title = "Instafilter"
        view.backgroundColor = .white
        
        addSubviews()
        setConstrainsts()
        setTargets()
    }

    private func addSubviews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        imageWrapper.addSubview(imageView)

        view.addSubview(imageWrapper)
        view.addSubview(sliderLabel)
        view.addSubview(imageSlider)
        view.addSubview(changeButton)
        view.addSubview(saveButton)
    }

    private func setConstrainsts() {
        imageWrapper.snp.makeConstraints {
            $0.height.equalTo(470.0)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(64.0)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }

        imageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10.0)
            $0.trailing.bottom.equalToSuperview().offset(-10.0)
        }

        sliderLabel.snp.makeConstraints {
            $0.width.equalTo(72.0)
            $0.height.equalTo(21.0)
            $0.top.equalTo(imageWrapper.snp.bottom).offset(24.0)
            $0.leading.equalToSuperview().offset(24.0)
        }

        imageSlider.snp.makeConstraints {
            $0.centerY.equalTo(sliderLabel.snp.centerY)
            $0.leading.equalTo(sliderLabel.snp.trailing).offset(12.0)
            $0.trailing.equalToSuperview().offset(-24.0)
        }

        changeButton.snp.makeConstraints {
            $0.top.equalTo(sliderLabel.snp.bottom).offset(24.0)
            $0.leading.equalToSuperview().offset(24.0)
        }

        saveButton.snp.makeConstraints {
            $0.top.equalTo(sliderLabel.snp.bottom).offset(24.0)
            $0.trailing.equalToSuperview().offset(-24.0)
        }
    }

    private func setTargets() {
        changeButton.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(tapSaveButtonapped), for: .touchUpInside)
        imageSlider.addTarget(self, action: #selector(imageSliderChangedValue), for: .valueChanged)
    }

    @objc private func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    @objc private func changeButtonTapped() {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(ac, animated: true)
    }

    @objc private func tapSaveButtonapped() {
        guard let image = imageView.image else {
            showAlert(title: "Ups!", message: "There is no chossen image")

            return
        }

        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
//        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image), nil) // This is the same as above
    }

    @objc private func imageSliderChangedValue() {
        applyProcessing()
    }

    @objc private func setFilter(_ action: UIAlertAction) {
        guard currentImage != nil else { 
            showAlert(title: "Ups!", message: "There is no chossen image")
            return
        }
        guard let actionTitle = action.title else { return }

        changeButton.setTitle(actionTitle, for: .normal)

        currentFilter = CIFilter(name: actionTitle)
        setImageToFilter()
        applyProcessing()
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        setSliderToMaxValue()
        cache(image)
        setImageToFilter()
        applyProcessing()
        dismiss(animated: true)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(title: "Save error", message: error.localizedDescription)
        } else {
            showAlert(title: "Saved!", message: "Your altered image has been saved to your photos.")
        }
    }

    private func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    func setSliderToMaxValue() {
        imageSlider.setValue(1.0, animated: true)
    }

    private func cache(_ image: UIImage) {
        currentImage = image
    }

    private func setImageToFilter() {
        let ciImage = CIImage(image: currentImage)
        currentFilter.setValue(ciImage, forKey: kCIInputImageKey)
    }

    private func applyProcessing() {
        guard let ciImage = currentFilter.outputImage else {
            return
        }

        adjustFilter()

        if let cgImg = context.createCGImage(ciImage, from: ciImage.extent) {
            let image = UIImage(cgImage: cgImg)
            show(image)
        }
    }

    private func adjustFilter() {
        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(imageSlider.value, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(imageSlider.value * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(imageSlider.value * 10, forKey: kCIInputScaleKey)
        }
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
        }
    }

    private func show(_ image: UIImage) {
        imageView.alpha = 0.0
        imageView.image = image

        UIView.animate(withDuration: 1, delay: 0.5, animations: {
            self.imageView.alpha = 1.0
        })
    }
}
