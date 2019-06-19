//
//  ReliableMessagingLibrary.swift
//  IOS Reliable Messaging Challenge
//
//  Created by Jafar Khoshtabiat on 6/16/19.
//  Copyright © 2019 Pushe. All rights reserved.
//

import Foundation
import RealmSwift

class ReliableMessagingLibrary {
    
    let realm: Realm
    var running: Bool
    var urlIndex: Int
    var messageIndex: Int
    
    init(realm: Realm) {
        self.realm = realm
        self.running = false
        
        let sentMessagesQuery = self.realm.objects(Message.self).filter("sent == true")
        for sentMessage in sentMessagesQuery {
            try! realm.write {
                realm.delete(sentMessage)
            }
        }
        
        let urlsQuery = self.realm.objects(ServerURL.self)
        for serverURL in urlsQuery {
            if serverURL.messages.count == 0 {
                try! realm.write {
                    realm.delete(serverURL)
                }
            }
        }
        
        self.urlIndex = self.realm.objects(ServerURL.self).max(ofProperty: "id") ?? 0
        self.messageIndex = self.realm.objects(Message.self).max(ofProperty: "id") ?? 0
    }
    
    func start() {
        guard !self.running else {
            fatalError("invalid state")
        }
        
        self.running = true
        let serverURLs = self.realm.objects(ServerURL.self)
        
        for serverURL in serverURLs {
            DispatchQueue.global(qos: .userInitiated).async {
                self.handleURL(serverURL: serverURL)

                DispatchQueue.main.async {
                    // MARK: TODO -> Update the UI
                }
            }
        }
    }
    
    func sendMessage(url: String, message: [String: String]) {
        let queryResult = self.realm.objects(ServerURL.self).filter("url == \(url)")
        
        guard queryResult.count <= 1 else {
            fatalError("invalid state")
        }
        
        if let serverURL = queryResult.first {
            let newMessage = Message(id: self.messageIndex + 1, message: message, serverURL: serverURL)
            try! self.realm.write {
                self.realm.add(newMessage)
            }
        } else {
            let serverURL = ServerURL(id: self.urlIndex + 1, url: url)
            let newMessage = Message(id: self.messageIndex + 1, message: message, serverURL: serverURL)
            try! self.realm.write {
                self.realm.add(serverURL)
            }
            self.urlIndex += 1
            
            try! self.realm.write {
                self.realm.add(newMessage)
            }
        }
        
        self.messageIndex += 1
        if !self.running {
            self.start()
        }
    }
    
    private func handleURL(serverURL: ServerURL) {
        let message = serverURL.messages.filter("sent == false").min(by: {(first, second) in
            guard first.id != second.id else {
                fatalError("invalid state")
            }
            
            return first.id < second.id
        })
    }
}
