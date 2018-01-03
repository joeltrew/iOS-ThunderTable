//
//  InputTextFieldViewCell.swift
//  ThunderTable
//
//  Created by Simon Mitchell on 15/09/2016.
//  Copyright © 2016 3SidedCube. All rights reserved.
//

import UIKit

open class InputDatePickerViewCell: TableViewCell {

    @IBOutlet weak public var textField: UITextField!
	
	public var datePicker = UIDatePicker()
	
	internal var dateFormatter: DateFormatter = DateFormatter()
		
    override open func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    override open func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
	
	open override func awakeFromNib() {
		
		super.awakeFromNib()
		
		let doneToolbar = UIToolbar()
		
		doneToolbar.items = [
			UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
			UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone(sender:)))
		]
		
		textField.inputView = datePicker
		textField.inputAccessoryView = doneToolbar
	}
	
	@objc private func handleDone(sender: UIBarButtonItem) {
		textField.resignFirstResponder()
	}
	
	@objc internal func updateLabel(sender: UIDatePicker) {
		textField.text = dateFormatter.string(from: sender.date)
	}
}
