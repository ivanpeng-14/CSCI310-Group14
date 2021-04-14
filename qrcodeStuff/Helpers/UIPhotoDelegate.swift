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
    
    // For uploading photo from URL
    func photoFromURL() {
        let urlRequest = UIAlertController(title: "URL", message: "Enter the URL below", preferredStyle: .alert)
        
        urlRequest.addTextField { (textField) in
            textField.placeholder = "https://www.yoururl.com"
        }
        
        urlRequest.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak urlRequest] (_) in
            let textField = urlRequest?.textFields![0]
            if let text = textField?.text, let url = URL(string: text) {
                self.downloadAndSetPhoto(from: url)
            }
        }))
        
        urlRequest.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(urlRequest, animated: true, completion: nil)
    }
    
    func alertError() {
        let error = UIAlertController(title: "Error", message: "Could get image from provided URL", preferredStyle: .alert)
        
        error.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {_ in }))
        
        self.present(error, animated: true, completion: nil)
    }
    
    func downloadAndSetPhoto(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                if let photo = UIImage(data: data){
                    self?.profilePhoto = photo
                } else{
                    self?.alertError()
                }
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
