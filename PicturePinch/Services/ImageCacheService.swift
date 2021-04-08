//
//  ImageCacheService.swift
//  PicturePinch
//
//  Created by Danny Grob on 08/04/2021.
//

import Foundation
import AlamofireImage

class ImageCacheService {
    static let imageCache = AutoPurgingImageCache( memoryCapacity: 111_111_111, preferredMemoryUsageAfterPurge: 90_000_000)

    static func add(key: String, image:UIImage) {
        imageCache.add(image, withIdentifier: key)
    }
    
    static func fetch(key:String) -> UIImage? {
        return imageCache.image(withIdentifier: key)
    }
}
