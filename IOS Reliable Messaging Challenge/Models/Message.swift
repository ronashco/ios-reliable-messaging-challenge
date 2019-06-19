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
    @objc dynamic var message: [String: String] = [String: String]()
    @objc dynamic var sent: Bool = false
    @objc dynamic var serverURL: ServerURL?
    
    convenience init(id: Int, message: [String: String], serverURL: ServerURL) {
        self.init()
        
        self.id = id
        self.message = message
        self.serverURL = serverURL
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func sendDone() {
        self.sent = true
    }
}
