//
//  LaodingView.swift
//  FlickrShowcase
//
//  Created by ShengHua Wu on 30/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import UIKit

final class LoadingView: UIView {
    // MARK: Properties
    private(set) lazy var spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override var isHidden: Bool {
        didSet {
            if isHidden {
                spinner.stopAnimating()
            } else {
                spinner.startAnimating()
            }
        }
    }
    
    // MARK: Designated Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        
        addSubview(spinner)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layouts
    override func layoutSubviews() {
        super.layoutSubviews()
        
        spinner.sizeToFit()
        spinner.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
}
