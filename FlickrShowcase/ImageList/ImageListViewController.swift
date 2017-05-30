//
//  ImageListViewController.swift
//  FlickrShowcase
//
//  Created by ShengHua Wu on 30/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import UIKit

// MARK: - Image List View Controller
final class ImageListViewController: UIViewController {
    // MARK: Properties
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.description())
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    var viewModel: ImageListViewModel!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let margin: CGFloat = 10.0
        let itemHeight: CGFloat = 100.0
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        layout.itemSize = CGSize(width: (view.bounds.width - margin * 4.0) / 3.0, height: itemHeight)
        layout.minimumInteritemSpacing = margin
        layout.minimumLineSpacing = margin
        
        collectionView.frame = view.bounds
    }
}

// MARK: - Collection View Data Source
extension ImageListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.state.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.description(), for: indexPath) as? ImageCell else {
            fatalError("Cell isn't ImageCell")
        }
        
//        viewModel.downloadImage(at: indexPath) { (url) in
//            guard cell.imageView.image == nil else { return }
//            
//            let data = try! Data(contentsOf: url)
//            cell.imageView.image = UIImage(data: data)
//        }
        
        return cell
    }
}
