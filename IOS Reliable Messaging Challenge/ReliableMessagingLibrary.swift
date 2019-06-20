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
    
    let mainRealm: Realm
    var running: Bool
    var urlIndex: Int
    var messageIndex: Int
    
    init(realm: Realm) {
        self.mainRealm = realm
        self.running = false
        
        let sentMessagesQuery = self.mainRealm.objects(Message.self).filter("sent == true")
        for sentMessage in sentMessagesQuery {
            try! realm.write {
                realm.delete(sentMessage)
            }
        }
        
        let urlsQuery = self.mainRealm.objects(ServerURL.self)
        for serverURL in urlsQuery {
            if serverURL.messages.count == 0 {
                try! realm.write {
                    realm.delete(serverURL)
                }
            }
        }
        
        self.urlIndex = self.mainRealm.objects(ServerURL.self).max(ofProperty: "id") ?? 0
        self.messageIndex = self.mainRealm.objects(Message.self).max(ofProperty: "id") ?? 0
    }
    
    func start() {
        guard !self.running else {
            fatalError("invalid state")
        }
        
        
        let serverURLs = self.mainRealm.objects(ServerURL.self)
        if serverURLs.count > 0 {
            self.running = true
            
            for serverURL in serverURLs {
                let url = serverURL.url
//                DispatchQueue.global(qos: .userInitiated).async {
                    self.handleURL(url: url, /*realm: try! Realm(), */failedTimes: 0)
//
//                    DispatchQueue.main.async {
//                        // MARK: TODO -> Update the UI
//                    }
//                }
            }
        }
        
    }
    
    func sendMessage(url: String, message: [String: String]) {
        let queryResult = self.mainRealm.objects(ServerURL.self).filter("url == %@", url)
        
        guard queryResult.count <= 1 else {
            fatalError("invalid state")
        }
        
        if let serverURL = queryResult.first {
            let newMessage = Message(id: self.messageIndex + 1, message: message, serverURL: serverURL)
            try! self.mainRealm.write {
                self.mainRealm.add(newMessage)
            }
        } else {
            let serverURL = ServerURL(id: self.urlIndex + 1, url: url)
            let newMessage = Message(id: self.messageIndex + 1, message: message, serverURL: serverURL)
            try! self.mainRealm.write {
                self.mainRealm.add(serverURL)
            }
            self.urlIndex += 1
            
            try! self.mainRealm.write {
                self.mainRealm.add(newMessage)
            }
        }
        
        self.messageIndex += 1
        if !self.running {
            self.start()
        }
    }
    
    private func handleURL(url: String, /*realm: Realm, */failedTimes: Int) {
//        if Thread.current.isMainThread {
//            fatalError("ops")
//        }
        let serverURL = self.mainRealm.objects(ServerURL.self).filter("url == %@", url).first!
        let message = self.mainRealm.objects(Message.self).filter("serverURL == %@ && sent == false", serverURL).min(by: {(first, second) in
            guard first.id != second.id else {
                fatalError("invalid state")
            }
            
            return first.id < second.id
        })
        
        if let _message = message {
            var params = [String: String]()
            for param in _message.message {
                params[param.key] = param.value
            }
            
            print("sending")
            MessagingServiceController().send(serverAddress: serverURL.url, message: params, successHandler: {
//                if Thread.current.isMainThread {
//                    fatalError("ops")
//                }
                print()
                try! self.mainRealm.write {
                    _message.sendDone()
//                    _message.sent = true
                }
                
                print("success")
                self.handleURL(url: url, /*realm: realm, */failedTimes: 0)
            }, errorHandler: {(errorMessage) in
                let delayTime = ExponentialBackoffUtility.getDelayTimeForCollision(collision: failedTimes + 1)
                print("failed")
                sleep(UInt32(delayTime))
                self.handleURL(url: url, /*realm: realm, */failedTimes: failedTimes + 1)
            })
        } else {
            let unsentMessages = self.mainRealm.objects(Message.self).filter("sent == false")
            if unsentMessages.count == 0 {
                self.running = false
                print("done")
            }
        }
    }
}
