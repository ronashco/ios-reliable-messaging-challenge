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
    
    var key: String? {
        didSet {
            guard let _key = self.key else {
                fatalError("invalid state for key variable")
            }
            
            self.keyTextField.text = _key
        }
    }
    
    var value: String? {
        didSet {
            guard let _value = self.value else {
                fatalError("invalid state for value variable")
            }
            
            self.valueTextField.text = _value
        }
    }
    
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
