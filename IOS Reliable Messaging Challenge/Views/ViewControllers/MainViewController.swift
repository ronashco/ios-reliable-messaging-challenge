//
//  MainViewController.swift
//  IOS Reliable Messaging Challenge
//
//  Created by Jafar Khoshtabiat on 6/16/19.
//  Copyright © 2019 Pushe. All rights reserved.
//

import UIKit
import RealmSwift

protocol MainViewControllerProtocol {
    func reloadAddParameterAvailability()
    func reloadSentMessages()
    func showMessageAsAlert(message: String)
}

class MainViewController: UIViewController {
    
    @IBOutlet var urlTextView: UITextView!
    @IBOutlet var messageKeysAndValuesTableView: UITableView!
    
    let urlTextViewPlaceHolder = "Enter server url here"
    
    var mainViewModel: MainViewModel?
    var messageLibrary: ReliableMessagingLibrary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let realm = try! Realm()
        self.messageLibrary = ReliableMessagingLibrary(realm: realm)
        self.messageLibrary?.delegate = self
        self.messageLibrary?.start()
        
        self.mainViewModel = self.mainViewModelFactory(realm: realm)
        
        self.urlTextView.text = self.urlTextViewPlaceHolder
        self.urlTextView.textColor = UIColor.lightGray
        self.urlTextView.delegate = self
        self.urlTextView.layer.borderColor = UIColor.black.cgColor
        self.urlTextView.layer.borderWidth = 2
        self.urlTextView.layer.cornerRadius = 4
        
        self.messageKeysAndValuesTableView.delegate = self
        self.messageKeysAndValuesTableView.dataSource = self
        self.messageKeysAndValuesTableView.register(UINib(nibName: "MessageKeyValueTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageKeyValueTableViewCell")
        self.messageKeysAndValuesTableView.register(UINib(nibName: "SendMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "SendMessageTableViewCell")
        self.messageKeysAndValuesTableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTableViewCell")
        
        self.messageKeysAndValuesTableView.layer.borderColor = UIColor.black.cgColor
        self.messageKeysAndValuesTableView.layer.borderWidth = 2
        self.messageKeysAndValuesTableView.layer.cornerRadius = 4
        
        self.messageLibrary?.sendMessage(url: "https://challenge.ronash.co/reliable-messaging", message: ["param1": "hello", "param2": "hey", "param3": "yo"])
        
        self.messageLibrary?.sendMessage(url: "https://challenge.ronash.co/reliable-messaging", message: ["param1": "hallow"])
        
        self.messageLibrary?.sendMessage(url: "https://challenge.ronash.co/reliable-messaging", message: ["param1": "lllll", "param2": "marhaba", "param3": "salam"])
    }
    
    private func mainViewModelFactory(realm: Realm) -> MainViewModel {
        return MainViewModel(vc: self, realm: realm)
    }
}

extension MainViewController: MainViewControllerProtocol {
    func reloadAddParameterAvailability() {
        self.messageKeysAndValuesTableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
    }
    
    func reloadSentMessages() {
        self.messageKeysAndValuesTableView.reloadSections([2], with: .none)
    }
    
    func showMessageAsAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIKit.UIAlertAction(title: "باشه", style: UIAlertAction.Style.default)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension MainViewController: ReliableMessagingLibraryDelegate {
    func sendMessageDone(url: String, message: [String : String]) {
        guard let viewModel = self.mainViewModel else {
            fatalError("invalid state for mainViewModel variable")
        }
        
        viewModel.sendMessageDone(url: url, message: message)
    }
    
    func allMessagesSuccessfullySent() {
        // MARK: TODO
    }
}

extension MainViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = self.urlTextViewPlaceHolder
            textView.textColor = UIColor.lightGray
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel = self.mainViewModel else {
            fatalError("invalid state for mainViewModel variable")
        }
        
        return viewModel.numberOfSectionsOfMessageKeysAndValuesTableView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = self.mainViewModel else {
            fatalError("invalid state for mainViewModel variable")
        }
        
        return viewModel.numberOfRowsInSectionOfMessageKeysAndValuesTableView(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 50
            
        case 1:
            return 40
            
        case 2:
            return UITableView.automaticDimension
            
        default:
            fatalError("invalid state for section of indexPath")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = self.mainViewModel else {
            fatalError("invalid state for mainViewModel variable")
        }
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageKeyValueTableViewCell", for: indexPath) as! MessageKeyValueTableViewCell
            cell.tag = indexPath.row
            cell.delegate = self
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SendMessageTableViewCell", for: indexPath) as! SendMessageTableViewCell
            cell.canAddParameter = viewModel.isAddParameterButtonAvailable()
            cell.delegate = self
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
            cell.url = viewModel.getSentMessageURL(index: indexPath.row)
            cell.message = viewModel.getSentMessage(index: indexPath.row)
            cell.hideBottomLine = viewModel.shouldHideBottomLineForSentMessageCell(index: indexPath.row)
            return cell
            
        default:
            fatalError("invalid state for section of indexPath")
        }
    }
}

extension MainViewController: MessageKeyValueTableViewCellDelegate {
    func messageKeyValueTableViewCellChangedKey(newKey: String, index: Int) {
        guard let viewModel = self.mainViewModel else {
            fatalError("invalid state for mainViewModel variable")
        }
        
        viewModel.messageKeyValueTableViewCellChangedKey(newKey: newKey, index: index)
    }
    
    func messageKeyValueTableViewCellChangedValue(newValue: String, index: Int) {
        guard let viewModel = self.mainViewModel else {
            fatalError("invalid state for mainViewModel variable")
        }
        
        viewModel.messageKeyValueTableViewCellChangedValue(newValue: newValue, index: index)
    }
}

extension MainViewController: SendMessageTableViewCellDelegate {
    func sendMessageTableViewCellWantsToSendMessage() {
        // MARK: TODO
    }
    
    func sendMessageTableViewCellWantsToAddParameter() {
        // MARK: TODO
    }
}

