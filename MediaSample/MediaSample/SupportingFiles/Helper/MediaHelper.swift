//
//  MediaHelper.swift
//  MediaSample
//
//  Created by Tolga Taner on 17.10.2020.
//

import UIKit.UIImagePickerController


protocol MediaHelperDelegate:class {
    func mediaHelper(didPickImage image:UIImage)
}

final class MediaHelper:NSObject {
    
    weak var delegate:MediaHelperDelegate?
    lazy private var imagePicker:UIImagePickerController = {
        let imagePicker:UIImagePickerController = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        return imagePicker
    }()
    
    func openAlbum(parentController controller:UIViewController){
        controller.present(self.imagePicker, animated: true) {}
    }
    
}



extension MediaHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true) { }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            self.imagePicker.dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                self.delegate?.mediaHelper(didPickImage: pickedImage)
            }
        }
    }
    
    
}

