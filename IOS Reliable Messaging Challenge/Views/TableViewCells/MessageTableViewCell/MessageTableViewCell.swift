//
//  MessageTableViewCell.swift
//  IOS Reliable Messaging Challenge
//
//  Created by Jafar Khoshtabiat on 6/21/19.
//  Copyright © 2019 Pushe. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet var urlLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var sentDoneView: UIView!
    @IBOutlet var bottomLineView: UIView!
    
    var url: String? {
        didSet {
            guard let _url = self.url else {
                fatalError("invalid state for url variable")
            }
            
            self.urlLabel.text = _url
        }
    }
    
    var message: String? {
        didSet {
            guard let _message = self.message else {
                fatalError("invalid state for message variable")
            }
            
            self.messageLabel.text = _message
        }
    }
    
    var hideBottomLine: Bool? {
        didSet {
            guard let _hideBottomLine = self.hideBottomLine else {
                fatalError("invalid state for hideBottomLine variable")
            }
            
            if _hideBottomLine {
                self.bottomLineView.isHidden = true
            } else {
                self.bottomLineView.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.sentDoneView.backgroundColor = UIColor.green
        self.sentDoneView.layer.cornerRadius = self.sentDoneView.frame.height / 2
        self.sentDoneView.layer.borderColor = UIColor.black.cgColor
        self.sentDoneView.layer.borderWidth = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
