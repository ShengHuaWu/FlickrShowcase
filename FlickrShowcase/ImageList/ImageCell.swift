//
//  ImageCell.swift
//  FlickrShowcase
//
//  Created by ShengHua Wu on 30/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import UIKit

final class ImageCell: UICollectionViewCell {
    // MARK: Properties
    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        return imageView
    }()
    
    // MRRK: Designated Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layouts
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = contentView.bounds
    }
    
    // MARK: Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
}
