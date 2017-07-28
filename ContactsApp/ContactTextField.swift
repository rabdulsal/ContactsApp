//
//  ContactTextField.swift
//  ContactsApp
//
//  Created by Rashad Abdul-Salaam on 7/28/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import UIKit

class ContactTextField : UITextField {
    
    var maxAllowableCharacters = 100
    
    var doneButtonCallBack: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
}

extension UIViewController {
    
    func makeDoneButtonToolBar() -> UIToolbar {
        // Add toolbar with done button on the right
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        let flexibleSeparator = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(UIViewController.doneButtonPressed(_:)))
        toolbar.items = [flexibleSeparator, doneButton]
        return toolbar
    }
    
    func makeDatePickerView() -> UIDatePicker {
        let datePicker = UIDatePicker()
        var components = DateComponents()
        components.year = -100
        let minDate = Calendar.current.date(byAdding: components, to: Date())
        
        components.year = -18
        let maxDate = Calendar.current.date(byAdding: components, to: Date())
        
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(UIViewController.dateChanged(_:)), for: .valueChanged)
        return datePicker
    }
    
    func doneButtonPressed(_ sender: Any) { }
    
    func dateChanged(_ datePicker: UIDatePicker) { }
}
