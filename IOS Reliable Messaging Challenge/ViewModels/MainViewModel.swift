//
//  MainViewModel.swift
//  IOS Reliable Messaging Challenge
//
//  Created by Jafar Khoshtabiat on 6/21/19.
//  Copyright © 2019 Pushe. All rights reserved.
//

import Foundation
import RealmSwift

class MainViewModel {
    let vc: MainViewControllerProtocol
    let realm: Realm
    var url: String
    var message: [(key: String, value: String)]
    var sentMessages: [Message]
    
    init(vc: MainViewControllerProtocol, realm: Realm) {
        self.vc = vc
        self.realm = realm
        self.url = ""
        self.message = [(key: "", value: "")]
        self.sentMessages = [Message]()
    }
    
    private func paramsToJSONString(params: [String: String]) -> String {
        var jsonFormatMessage = "{\n"
        for param in params {
            jsonFormatMessage += "    \(param.key): \(param.value)\n"
        }
        jsonFormatMessage += "}"
        
        return jsonFormatMessage
    }
    
    func allMessagesSuccessfullySent() {
        let alertMessage = "All messages sent successfully"
        self.vc.showToastMessage(message: alertMessage, duration: 2, position: .top)
    }
    
    func urlTextViewDidChange(newText: String) {
        let oldURL = self.url
        self.url = newText
        
        if (oldURL.isEmpty && !self.url.isEmpty) || (!oldURL.isEmpty && self.url.isEmpty) {
            self.vc.reloadButtonsAvailability()
        }
    }
}

// messageKeysAndValuesTableView related functionalities
extension MainViewModel {
    func numberOfSectionsOfMessageKeysAndValuesTableView() -> Int {
        return 3
    }
    
    func numberOfRowsInSectionOfMessageKeysAndValuesTableView(section: Int) -> Int {
        switch section {
        case 0:
            return self.message.count
            
        case 1:
            return 1
            
        case 2:
            return self.sentMessages.count
            
        default:
            fatalError("invalid state for section variable")
        }
    }
    
    func getKeyForParameter(index: Int) -> String {
        return self.message[index].key
    }
    
    func getValueForParameter(index: Int) -> String {
        return self.message[index].value
    }
    
    func isSendButtonAvailable() -> Bool {
        let lastParam = self.message.last
        return !self.url.isEmpty && !lastParam!.key.isEmpty && !lastParam!.value.isEmpty
    }
    
    func isAddParameterButtonAvailable() -> Bool {
        let lastParam = self.message.last
        return !lastParam!.key.isEmpty && !lastParam!.value.isEmpty
    }
    
    func isRemoveParameterButtonAvailable() -> Bool {
        return self.message.count > 1
    }
    
    func getSentMessageURL(index: Int) -> String {
        return self.sentMessages[index].serverURL!.url
    }
    
    func getSentMessage(index: Int) -> String {
        let paramsList = self.sentMessages[index].message
        var params = [String: String]()
        for param in paramsList {
            params[param.key] = param.value
        }
        return self.paramsToJSONString(params: params)
    }
    
    func shouldHideBottomLineForSentMessageCell(index: Int) -> Bool {
        if index == self.sentMessages.count - 1 {
            return true
        } else {
            return false
        }
    }
    
    func messageKeyValueTableViewCellChangedKey(newKey: String, index: Int) {
        let prevParam = self.message[index]
        let oldKey = prevParam.key
        self.message[index] = (key: newKey, value: prevParam.value)
        
        if (oldKey.isEmpty && !newKey.isEmpty) || (!oldKey.isEmpty && newKey.isEmpty) {
            self.vc.reloadButtonsAvailability()
        }
    }
    
    func messageKeyValueTableViewCellChangedValue(newValue: String, index: Int) {
        let prevParam = self.message[index]
        let oldValue = prevParam.value
        self.message[index] = (key: prevParam.key, value: newValue)
        
        if (oldValue.isEmpty && !newValue.isEmpty) || (!oldValue.isEmpty && newValue.isEmpty) {
          self.vc.reloadButtonsAvailability()
        }
    }
    
    func sendMessageDone(url: String, message: [String : String]) {
        switch UIApplication.shared.applicationState {
        case .background, .inactive:
            self.sentMessages.removeAll()
            let sentMessagesQuery = self.realm.objects(Message.self).filter("sent == true").sorted(byKeyPath: "id", ascending: true)
            for sentMessage in sentMessagesQuery {
                self.sentMessages.append(sentMessage)
            }
            
            self.vc.reloadSentMessages()
            
        case .active:
            let alertMessage = "Message: \n\(self.paramsToJSONString(params: message))\nsent to \(url))"
            self.vc.showToastMessage(message: alertMessage, duration: 0.2, position: .bottom)
            
            self.sentMessages.removeAll()
            let sentMessagesQuery = self.realm.objects(Message.self).filter("sent == true").sorted(byKeyPath: "id", ascending: true)
            for sentMessage in sentMessagesQuery {
                self.sentMessages.append(sentMessage)
            }
            
            self.vc.reloadSentMessages()
            
        default:
            break
        }
    }
    
    func sendMessageTableViewCellWantsToSendMessage() {
        var params = [String: String]()
        for param in self.message {
            params[param.key] = param.value
        }
        
        self.vc.giveMessageToReliableMessagingLibrary(url: self.url, message: params)
        
        self.vc.resetURLTextView()
        self.url = ""
        self.message = [(key: "", value: "")]
        self.vc.reloadParameters()
        print()
    }
    
    func sendMessageTableViewCellWantsToAddParameter() {
        self.message.append((key: "", value: ""))
        self.vc.addParameter(indexPath: IndexPath(row: self.message.count - 1, section: 0))
        self.vc.reloadButtonsAvailability()
    }
    
    func sendMessageTableViewCellWantsToRemoveParameter() {
        self.message.removeLast()
        self.vc.removeParameter(indexPath: IndexPath(row: self.message.count, section: 0))
        self.vc.reloadButtonsAvailability()
    }
}
