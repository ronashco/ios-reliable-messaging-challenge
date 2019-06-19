//
//  ServerURL.swift
//  IOS Reliable Messaging Challenge
//
//  Created by Jafar Khoshtabiat on 6/16/19.
//  Copyright © 2019 Pushe. All rights reserved.
//

import Foundation
import RealmSwift

class ServerURL: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var url: String = ""
    
    let messages = LinkingObjects(fromType: Message.self, property: "serverURL")
    
    convenience init(id: Int, url: String) {
        self.init()
        
        self.id = id
        self.url = url
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

