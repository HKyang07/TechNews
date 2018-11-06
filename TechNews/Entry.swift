//
//  Entry.swift
//  TechNews
//
//  Created by Felix on 2018/10/19.
//  Copyright © 2018 Felix. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class Entry: Object, Mappable {
    @objc dynamic var content : String = ""
    @objc dynamic var url : String = ""
    @objc dynamic var time : Date?
    @objc dynamic var title : String = "initial"
    @objc dynamic var author : String = "anonymous"
    @objc dynamic var type : String = ""
    @objc dynamic var id : Int64 = 0
    @objc dynamic var customid : String = ""

    required convenience init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    override class func primaryKey() -> String {
        return "customid"
    }
    
    func mapping(map: Map) {
        content         <- map["text"]
        url             <- map["url"]
        time            <- (map["time"], DateTransform())
        title           <- map["title"]
        author          <- map["by"]
        id              <- map["id"]
        type            <- map["type"]
    }

}
