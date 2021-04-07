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
    
    var photo:Albums.Contents.ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let cachedImage = photo?.cachedImage {
            self.setImage(cachedImage)
        } else if let urlString = photo?.url, let url = URL(string:urlString) {
            let downloader = ImageDownloader()
            let urlRequest = URLRequest(url: url)
            
            downloader.download(urlRequest, completion:  { [weak self] (response) in
                guard let self = self else { return }
                if case .success(let image) = response.result {
                    self.setImage(image)
                    self.scrollView.setZoomScale()
                }
            })
        }
        
        self.title = photo?.title
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
