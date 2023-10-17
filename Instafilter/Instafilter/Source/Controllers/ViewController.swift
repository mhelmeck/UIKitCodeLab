//
//  ViewController.swift
//  Instafilter
//
//  Created by Maciej Helmecki on 17/10/2023.
//

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
        button.setTitle("Change Filter", for: .normal)
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

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

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

    }

    @objc private func tapSaveButtonapped() {

    }

    @objc private func imageSliderChangedValue(_ slider: UISlider) {

    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        cacheAndsShowImage(image)
        dismiss(animated: true)
    }

    private func cacheAndsShowImage(_ image: UIImage) {
        currentImage = image
        imageView.image = image
    }
}
