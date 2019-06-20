//
//  MessagingService.swift
//  IOS Reliable Messaging Challenge
//
//  Created by Jafar Khoshtabiat on 6/19/19.
//  Copyright © 2019 Pushe. All rights reserved.
//

import Foundation
import Moya

enum MessagingService {
    case sendMessage(serverAddress: String, message: [String: String])
}

extension MessagingService: TargetType {
    var baseURL: URL {
        switch self {
        case let .sendMessage(serverAddress: serverAddress, message: _):
            return URL(string: serverAddress)!
        }
    }
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        var params = [String: String]()
        switch self {
        case let .sendMessage(serverAddress: _, message: message):
            for param in message {
                params[param.key] = param.value
            }
        }
        
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
