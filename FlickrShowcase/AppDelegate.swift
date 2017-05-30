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
        ImageProvider.setUp()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        router.configure(window)
        
        return true
    }
}

struct Router {
    func configure(_ window: UIWindow?) {
        window?.backgroundColor = .white
        
        let imageListVC = ImageListViewController()
        configure(imageListVC)
        
        let navigationController = UINavigationController(rootViewController: imageListVC)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func configure(_ imageListViewController: ImageListViewController) {
        imageListViewController.title = "Images"
        
        let viewModel = ImageListViewModel { [weak viewController = imageListViewController] (state) in
            viewController.flatMap { $0.updateUI(with: state) }
        }
        imageListViewController.viewModel = viewModel
        
        imageListViewController.presentError = { [weak viewController = imageListViewController] (error) in
            guard let imageListVC = viewController else { return }
            
            let alert = UIAlertController.makeAlert(with: error)
            imageListVC.present(alert, animated: true, completion: nil)
        }
        
        imageListViewController.presentSearching = { [weak viewController = imageListViewController] in
            let searchingVC = SearchingViewController()
            self.configure(searchingVC)
            
            let navigationController = UINavigationController(rootViewController: searchingVC)
            
            viewController.flatMap{ $0.present(navigationController, animated: true, completion: nil) }
        }
    }
    
    func configure(_ searchingViewController: SearchingViewController) {
        searchingViewController.title = "Search"
    }
}
