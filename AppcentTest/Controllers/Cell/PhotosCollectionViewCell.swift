//
//  PhotosCollectionViewCell.swift
//  AppcentText
//
//  Created by Amir Daliri on 5/8/20.
//  Copyright © 2020 Amir Daliri. All rights reserved.
//

import UIKit
import Kingfisher

class PhotosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        image.layer.cornerRadius = 8.0
        image.layer.masksToBounds = true
    }
    
    // MARK: - Download Image Method
    func downloadImg(url: URL) {
        let processor = DownsamplingImageProcessor(size: image.bounds.size)
        image.kf.indicatorType = .activity
        image.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]) { result in }
    }
}

// MARK: - Cell Identifire Method
extension PhotosCollectionViewCell {
    static let identifire = "photosCell"
}
