//
//  Photo.swift
//  AppcentText
//
//  Created by Amir Daliri on 5/8/20.
//  Copyright © 2020 Amir Daliri. All rights reserved.
//

import XMLMapper

class Photo: XMLMappable {
    
    var nodeName: String!
    var id: String?
    var owner: String?
    var secret: String?
    var server: String?
    var farm: String?
    var title: String?
    var ispublic: String?
    var isfriend: String?
    var isfamily: String?
    
    required init?(map: XMLMap) {}

    func mapping(map: XMLMap) {
        id <- map["_id"]
        owner <- map["_owner"]
        secret <- map["_secret"]
        server <- map["_server"]
        farm <- map["_farm"]
        title <- map["_title"]
        ispublic <- map["_ispublic"]
        isfriend <- map["_isfriend"]
        isfamily <- map["_isfamily"]
    }
}
