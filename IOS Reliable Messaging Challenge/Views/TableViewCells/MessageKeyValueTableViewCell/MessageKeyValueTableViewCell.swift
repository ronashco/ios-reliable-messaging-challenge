//
//  MessageKeyValueTableViewCell.swift
//  IOS Reliable Messaging Challenge
//
//  Created by Jafar Khoshtabiat on 6/21/19.
//  Copyright © 2019 Pushe. All rights reserved.
//

import UIKit

protocol MessageKeyValueTableViewCellDelegate {
    func messageKeyValueTableViewCellChangedKey(newKey: String, index: Int)
    func messageKeyValueTableViewCellChangedValue(newValue: String, index: Int)
}

class MessageKeyValueTableViewCell: UITableViewCell {

    @IBOutlet var keyTextField: UITextField!
    @IBOutlet var valueTextField: UITextField!
    @IBOutlet var bottomLineView: UIView!
    
    var delegate: MessageKeyValueTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.keyTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.valueTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        switch textField {
        case self.keyTextField:
            guard let key = self.keyTextField.text else {
                fatalError("invalid state")
            }
            
            self.delegate?.messageKeyValueTableViewCellChangedKey(newKey: key, index: self.tag)
            
        case self.valueTextField:
            guard let value = self.valueTextField.text else {
                fatalError("invalid state")
            }
            
            self.delegate?.messageKeyValueTableViewCellChangedValue(newValue: value, index: self.tag)
            
        default:
            fatalError("invalid state")
        }
    }
}
