//
//  AppDelegate.swift
//  PicturePinch
//
//  Created by Danny Grob on 01/04/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13.0, *) {
            let standard = UINavigationBarAppearance()
                 
            standard.configureWithOpaqueBackground()

            standard.backgroundColor = UIColor.init(named: "pinchBlue")
            standard.titleTextAttributes = [.foregroundColor: UIColor.white]
            
            standard.buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
            standard.doneButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
            standard.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
            UINavigationBar.appearance().standardAppearance = standard
            UINavigationBar.appearance().tintColor = UIColor.init(named: "pinchGreen")
        } else {
            UINavigationBar.appearance().backgroundColor = UIColor.init(named: "pinchBlue")
            UINavigationBar.appearance().barTintColor = UIColor.init(named: "pinchBlue")
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
            UINavigationBar.appearance().tintColor = UIColor.init(named: "pinchGreen")
            UINavigationBar.appearance().isTranslucent = false
        }
        
        return true
    }


}

