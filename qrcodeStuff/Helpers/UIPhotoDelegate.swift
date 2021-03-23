//
//  ProfileDelegate.swift
//  Trojan Check In
//
//  Created by Carlos Lao on 2021/3/21.
//

import PhotosUI

class UIPhotoDelegate: UIViewController, PHPickerViewControllerDelegate {
    var profilePhoto: UIImage? {
        didSet {
            self.didSetPhoto()
        }
    }
    
    var config = PHPickerConfiguration()
    
    // Set Up Config
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config.filter = .images
    }
    
    // Protocol Requirement
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            let prevImage = profilePhoto
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                let image = object as? UIImage
                DispatchQueue.main.async {
                    guard let self = self, self.profilePhoto == prevImage else { return }
                    self.profilePhoto = image
                }
            }
        }
    }
    
    // Generate and Presents Picker
    func presentPicker() {
        let photoPicker = PHPickerViewController(configuration: self.config)
        photoPicker.delegate = self
        self.present(photoPicker, animated: true, completion: nil)
    }
    
    func didSetPhoto() {
        print("The photo has changed.")
    }
}
