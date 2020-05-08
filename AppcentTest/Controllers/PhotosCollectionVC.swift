//
//  ViewController.swift
//  AppcentText
//
//  Created by Amir Daliri on 5/8/20.
//  Copyright © 2020 Amir Daliri. All rights reserved.
//

import UIKit
import Kingfisher

class PhotosCollectionVC: UICollectionViewController {

    var page = 1
    var imgLinks: [URL] = []
    var imges = [UIImage]()
    private var layout: BaseLayout!

    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // I'm Here...
        setupView()
    }
    
    
    // MARK: - Setup View Method
    func setupView() {
        layout = FlickrLayout()
        collectionView.collectionViewLayout = layout
        collectionView.setContentOffset(CGPoint.zero, animated: false)
        layout.contentPadding = ItemsPadding(horizontal: 15, vertical: 15)
        layout.cellsPadding = ItemsPadding(horizontal: 10, vertical: 10)
        Loading.show()
        getImages()
    }
    
    // MARK: - API Method
    
    fileprivate func getImages() {
        ApiRequest.shared.getPhotos(perPage: 20, page: page) { (success, res) in
            if let list = res?.photos {
                for i in list {
                    if i.ispublic == "1" {
                        guard let photoId = i.id,
                            let secret = i.secret,
                            let farm = i.farm,
                            let server = i.server
                            else { return }
                        let strLink = "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_m.jpg"
                        guard let link = URL(string: strLink) else {return}
                        self.imgLinks.append(link)
                    }
                }
                self.collectionView.reloadData()
                self.page += 1
                Loading.hide()
            }
        }
    }
}

// MARK: - UICollectionView Extensions Methode

extension PhotosCollectionVC {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgLinks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotosCollectionViewCell = (collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.identifire, for: indexPath as IndexPath) as? PhotosCollectionViewCell)!
        cell.downloadImg(url: imgLinks[indexPath.item])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == imgLinks.count - 1 {
            getImages()
        }
    }
}
