//
//  PhotoViewController.swift
//  PicturePinch
//
//  Created by Danny Grob on 04/04/2021.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class PhotoViewController: UIViewController {
    var scrollView: ImageScrollView!
    
    var photo:Pictures.List.ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = photo?.title
    
        self.loadPicture()
    }
    
    func loadPicture() {
        guard let photoURL = photo?.url else {
            return
        }
        if let cachedImage = ImageCacheService.fetch(key: photoURL) {
            self.setImage(cachedImage)
        } else if let url = URL(string: photoURL) {
            let downloader = ImageDownloader()
            let urlRequest = URLRequest(url: url)
            
            downloader.download(urlRequest, completion:  { [weak self] (response) in
                guard let self = self else { return }
                if case .success(let image) = response.result {
                    self.setImage(image)
                    self.scrollView.setZoomScale()
                    ImageCacheService.add(key: photoURL, image: image)
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setImage(_ image:UIImage) {
        self.scrollView = ImageScrollView(image: image)
        self.view.addSubview(self.scrollView)
        scrollView.frame = view.frame
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
