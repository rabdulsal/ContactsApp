//
//  EditContactViewController.swift
//  ContactsApp
//
//  Created by Rashad Abdul-Salaam on 7/26/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import UIKit

enum EditUserContext : Int {
    case newUser = 0
    case existingUser
}

protocol ContactCreatable {
    func didSuccessfullyCreateContact(contact: Contact)
    func didFailToCreateContact(error: NSError)
}

class EditContactViewController: UIViewController {
    
    // For creating new accounts and editing existing accounts
    
    // Name & zip fields
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var zipcodeField: UITextField!
    
    // Birthday fields
    @IBOutlet weak var birthMonthField: UITextField!
    @IBOutlet weak var birthDateField: UITextField!
    @IBOutlet weak var birthYearField: UITextField!
    
    // Phone number fields
    @IBOutlet weak var areacodeField: UITextField!
    @IBOutlet weak var threeDigitField: UITextField!
    @IBOutlet weak var fourDigitField: UITextField!
    
    
    var updateContext: EditUserContext = .newUser

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: IBActions

    @IBAction func pressedCancelButton(_ sender: Any) {
        // TODO: Alert requesting 'Are you sure'
        self.dismiss(animated: true)
    }
    
    @IBAction func pressedUpdateContactButton(_ sender: Any) {
        // Run UpdateContactService to store / update Core Data
    }
    
    
}

