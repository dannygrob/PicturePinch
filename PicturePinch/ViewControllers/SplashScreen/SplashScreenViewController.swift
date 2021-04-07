//
//  SplashScreen.swift
//  PicturePinch
//
//  Created by Danny Grob on 01/04/2021.
//

import Foundation
import UIKit

class SplashScreenViewController:UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now()  + 2) {
            if let album = UIStoryboard.init(name: "Albums", bundle: Bundle.main).instantiateInitialViewController() as? AlbumsViewController {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.navigationController?.viewControllers = [album]
            }
        }
        
    }
}
