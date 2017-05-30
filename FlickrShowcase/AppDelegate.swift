//
//  AppDelegate.swift
//  FlickrShowcase
//
//  Created by ShengHua Wu on 30/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let router = Router()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        router.configure(window)
        
        return true
    }
}

struct Router {
    func configure(_ window: UIWindow?) {
        window?.backgroundColor = .white
        
        let imageListVC = ImageListViewController()
        let navigationController = UINavigationController(rootViewController: imageListVC)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

