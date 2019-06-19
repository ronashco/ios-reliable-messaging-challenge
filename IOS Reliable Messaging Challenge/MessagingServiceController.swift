//
//  MessagingServiceController.swift
//  IOS Reliable Messaging Challenge
//
//  Created by Jafar Khoshtabiat on 6/19/19.
//  Copyright © 2019 Pushe. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

class MessagingServiceController {
    let moyaProvider: MoyaProvider<MessagingService>
    
    init() {
        self.moyaProvider = MoyaProvider<MessagingService>()
    }
    
    func send(serverAddress: String, message: [String: String], successHandler: @escaping () -> (), errorHandler: @escaping (String) -> ()) {
        self.moyaProvider.request(.sendMessage(serverAddress: serverAddress, message: message), completion: {(result) in
            switch result {
            case let .success(moyaResponse):
                let statusCode = moyaResponse.statusCode
                switch statusCode {
                case 200:
                    successHandler()
                    
                case 500:
                    errorHandler("statusCode 500")
                    
                default:
                    fatalError("invalid state")
                }
                
            case let .failure(error):
                errorHandler(error.localizedDescription)
            }
        })
    }
}
