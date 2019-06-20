//
//  MainViewController.swift
//  IOS Reliable Messaging Challenge
//
//  Created by Jafar Khoshtabiat on 6/16/19.
//  Copyright © 2019 Pushe. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    var messageLibrary: ReliableMessagingLibrary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let realm = try! Realm()
        self.messageLibrary = ReliableMessagingLibrary(realm: realm)
        self.messageLibrary?.start()
        
        self.messageLibrary?.sendMessage(url: "https://challenge.ronash.co/reliable-messaging", message: ["param1": "hello", "param2": "hey", "param3": "yo"])
        
        self.messageLibrary?.sendMessage(url: "https://challenge.ronash.co/reliable-messaging", message: ["param1": "hallow"])
        
        self.messageLibrary?.sendMessage(url: "https://challenge.ronash.co/reliable-messaging", message: ["param1": "lllll", "param2": "marhaba", "param3": "salam"])
    }
}

