//
//  ExponentialBackoffUtility.swift
//  IOS Reliable Messaging Challenge
//
//  Created by Jafar Khoshtabiat on 6/20/19.
//  Copyright © 2019 Pushe. All rights reserved.
//

import Foundation

class ExponentialBackoffUtility {
    static func getDelayTimeForCollision(collision: Int) -> Int {
        var n = 1
        for _ in 0 ..< (collision <= 20 ? collision : 20) {
            n *= 2
        }
        n -= 1
        
        var sum = 0
        for value in 0 ... n {
            sum += value
        }
        
        return Int(sum / (n + 1))
    }
}
