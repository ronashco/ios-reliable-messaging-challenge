//
//  SendMessageTableViewCell.swift
//  IOS Reliable Messaging Challenge
//
//  Created by Jafar Khoshtabiat on 6/21/19.
//  Copyright © 2019 Pushe. All rights reserved.
//

import UIKit

protocol SendMessageTableViewCellDelegate {
    func sendMessageTableViewCellWantsToSendMessage()
    func sendMessageTableViewCellWantsToAddParameter()
}

class SendMessageTableViewCell: UITableViewCell {

    @IBOutlet var addParameterButton: UIButton!
    
    var delegate: SendMessageTableViewCellDelegate?
    
    var canAddParameter: Bool? {
        didSet {
            guard let _canAddParameter = self.canAddParameter else {
                fatalError("invalid state for canAddParameter variable")
            }
            
            if _canAddParameter {
                self.addParameterButton.isHidden = false
            } else {
                self.addParameterButton.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func sendButtonTouchUpInside(_ sender: UIButton) {
        self.delegate?.sendMessageTableViewCellWantsToSendMessage()
    }
    
    @IBAction func addParameterButtonTouchUpInside(_ sender: UIButton) {
        self.delegate?.sendMessageTableViewCellWantsToAddParameter()
    }
}