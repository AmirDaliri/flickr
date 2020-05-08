//
//  Photos.swift
//  AppcentText
//
//  Created by Amir Daliri on 5/8/20.
//  Copyright © 2020 Amir Daliri. All rights reserved.
//

import XMLMapper

class Photos: XMLMappable {
    
    var nodeName: String!
    var photos: [Photo]?
    var page: Int?
    var pages: Int?
    var perPage: Int?
    var total: Int?
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        photos <- map["photo"]
        page <- map["_page"]
        pages <- map["_pages"]
        perPage <- map["_perpage"]
        total <- map["_total"]
    }
    
}
