//
//  Message.swift
//  IOS Reliable Messaging Challenge
//
//  Created by Jafar Khoshtabiat on 6/16/19.
//  Copyright © 2019 Pushe. All rights reserved.
//

import Foundation
import RealmSwift

class Message: Object {
    @objc dynamic var id: Int = 0
//    @objc dynamic var message: [String: String] = [String: String]()
    let message = List<RMLDictionary>()
    @objc dynamic var sent: Bool = false
    @objc dynamic var serverURL: ServerURL?
    
    convenience init(id: Int, message: [String: String], serverURL: ServerURL) {
        self.init()
        
        self.id = id
        var _message = List<RMLDictionary>()
        for param in message {
//            _message.append(RMLDictionary(key: param.key, value: param.value))
            self.message.append(RMLDictionary(key: param.key, value: param.value))
        }
//        self.message = _message
        self.serverURL = serverURL
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func sendDone() {
        self.sent = true
    }
}

class Person: Object {
    dynamic var name = ""
    
}

class RMLDictionary: Object {
    @objc dynamic var key: String = ""
    @objc dynamic var value: String = ""
    
    convenience init(key: String, value: String) {
        self.init()
        
        self.key = key
        self.value = value
    }
}
