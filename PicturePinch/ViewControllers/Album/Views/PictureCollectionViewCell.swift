//
//  PictureCollectionViewCell.swift
//  PicturePinch
//
//  Created by Danny Grob on 01/04/2021.
//

import Foundation
import UIKit
import AlamofireImage

class PictureCollectionViewCell:UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var imageURL:String? {
        didSet {
            guard let imageURL = imageURL else {
                return
            }
            
            self.imageView.image = nil
            
            if let cachedImage = ImageCacheService.fetch(key: imageURL) {
                self.imageView?.image = cachedImage
            } else if let url = URL(string: imageURL) {
                imageView?.af.setImage(withURL: url, completion:  { (response) in
                    if let image = response.value {
                        ImageCacheService.add(key: url.absoluteString, image: image)
                    }
                })
            }
        }
    }
}
