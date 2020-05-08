//
//  PhotoModel.swift
//  AppcentText
//
//  Created by Amir Daliri on 5/8/20.
//  Copyright © 2020 Amir Daliri. All rights reserved.
//

import XMLMapper

class BasePhotosResponse: XMLMappable {
    var nodeName: String!
    
    var photos: Photos?
    
    required init?(map: XMLMap) {}

    func mapping(map: XMLMap) {
        photos <- map["photos"]
    }
}
