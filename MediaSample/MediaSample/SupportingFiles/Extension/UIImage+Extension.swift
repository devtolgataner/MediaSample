//
//  UIImage+Extension.swift
//  MediaSample
//
//  Created by Tolga Taner on 18.10.2020.
//

import UIKit.UIImage

extension UIImage {

    var pngRepresentationData: Data? {
        return pngData()
    }

    var jpegRepresentationData: Data? {
        return jpegData(compressionQuality: 1.0)
    }
}

