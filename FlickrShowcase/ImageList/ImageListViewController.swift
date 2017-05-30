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
        collectionView.delegate = self
        
        return collectionView
    }()
    
    private lazy var loadingView: LoadingView = {
        let view = LoadingView(frame: .zero)
        view.isHidden = true
        
        return view
    }()
    
    var viewModel: ImageListViewModel!
    var presentError: ((Error) -> ())?
    var presentSearching: (() -> ())?
        
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchAction(sender:)))
        navigationItem.rightBarButtonItem = searchButtonItem
        
        view.addSubview(collectionView)
        view.addSubview(loadingView)
        
        viewModel.fetchPhotos(for: "kittens")
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
        loadingView.frame = view.bounds
    }
    
    // MARK: Actions
    func searchAction(sender: UIBarButtonItem) {
        presentSearching?()
    }
    
    // MARK: Public Methods
    func updateUI(with state: State<[FlickrPhoto]>) {
        switch state {
        case .loading:
            loadingView.isHidden = false
        case let .error(error):
            loadingView.isHidden = true
            presentError?(error)
        case .normal:
            loadingView.isHidden = true
            collectionView.reloadData()
        }
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
        
        viewModel.downloadImage(at: indexPath) { (url) in
            guard cell.usePlaceholder else { return }
            
            let data = try! Data(contentsOf: url)
            cell.imageView.image = UIImage(data: data)
            cell.usePlaceholder = false
        }
        
        return cell
    }
}

// MARK: - Collection View Delegate
extension ImageListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.item == viewModel.state.count - 1 else { return }
        
        viewModel.fetchPhotos(for: "kittens")
    }
}

// MARK: - Scroll View Delegate
extension ImageListViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        viewModel.suspendDownloadingImage()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate, case .normal = viewModel.state else { return }
        
        viewModel.resumeDownloadingImage()
        collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard case .normal = viewModel.state else { return }
        
        viewModel.resumeDownloadingImage()
        collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
    }
}
