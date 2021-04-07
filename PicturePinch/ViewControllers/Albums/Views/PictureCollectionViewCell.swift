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
            if let urlString = imageURL, let url = URL(string: urlString) {
                imageView?.af.setImage(withURL: url)
            }
        }
    }
}
