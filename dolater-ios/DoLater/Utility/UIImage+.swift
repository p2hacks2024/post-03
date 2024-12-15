//
//  UIImage+.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import CoreImage
import SwiftUI

extension UIImage {
    func cropping(to rect: CGRect) -> UIImage? {
        let croppingRect = imageOrientation.isLandscape ? rect.switched : rect
        guard let cgImage = cgImage?.cropping(to: croppingRect) else {
            return nil
        }
        return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
    }

    func resizing(to size: CGSize) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension UIImage.Orientation {
    var isLandscape: Bool {
        switch self {
        case .up, .down, .upMirrored, .downMirrored:
            return false
        case .left, .right, .leftMirrored, .rightMirrored:
            return true
        @unknown default:
            return false
        }
    }
}

extension CGRect {
    var switched: CGRect {
        return CGRect(x: minY, y: minX, width: height, height: width)
    }
}
