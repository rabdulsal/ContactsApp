//
//  EditContactViewController.swift
//  ContactsApp
//
//  Created by Rashad Abdul-Salaam on 7/26/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import UIKit
import CoreData

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
    
    
    var contactDelegate: ContactCreatable?
    var editingContact: Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
        
        guard
            let firstName = firstNameField.text,
            let lastName = lastNameField.text,
            let zipcode = zipcodeField.text else
        {
            return
        }
        
        guard
            let areacode = areacodeField.text,
            let threeDigit = threeDigitField.text,
            let fourDigit = fourDigitField.text else
        {
            return
        }
        
        guard
            let birthMo = birthMonthField.text,
            let birthdate = birthDateField.text,
            let birthYear = birthYearField.text else
        {
            return
        }
        
        
        let phone = ContactService.makePhoneNumber(with: areacode, firstThreeDigits: threeDigit, lastFourDigits: fourDigit)
        let birthday = ContactService.makeBirthDate(with: birthMo, birthDay: birthdate, birthYear: birthYear)
        //let contact = Contact(firstName: firstName, lastName: lastName, birthday: birthday, phone: phone, zipcode: zipcode)
        saveContact(with: firstName, lastName: lastName, birthday: birthday, phone: phone, zipcode: zipcode)
    }
    
    
}

fileprivate extension EditContactViewController {
    func setup() {
        if let contact = editingContact {
            decorateTextfields(with: contact)
        }
    }
    
    func decorateTextfields(with contact: Contact) {
        firstNameField.text = contact.firstName
        lastNameField.text  = contact.lastName
        zipcodeField.text   = contact.zipcode
        
        
        //birthMonthField: UITextField!
       // birthDateField: UITextField!
        //birthYearField: UITextField!
        
        
        //areacodeField.text  = contact.areacode
        //threeDigitField: UITextField!
        //fourDigitField: UITextField!
    }
    
    func saveContact(with firstName: String, lastName: String, birthday: String, phone: String, zipcode: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let contact = Contact(context: managedContext)
        contact.firstName = firstName
        contact.lastName = lastName
        contact.birthday = birthday
        contact.phone = phone
        contact.zipcode = zipcode
        
        //let entity = NSEntityDescription.entity(forEntityName: "Contact", in: managedContext)!
        
        //let contact = NSManagedObject(entity: entity, insertInto: managedContext)
        
        //contact.setValue(firstName, forKeyPath: "firstName")
        //contact.setValue(lastName, forKeyPath: "lastName")
        //contact.setValue(birthday, forKeyPath: "birthday")
        //contact.setValue(phone, forKeyPath: "phone")
        //contact.setValue(zipcode, forKeyPath: "zipcode")
        appDelegate.saveContext()
        self.dismiss(animated: true)
        
        // OLD CODE
        //do {
        //    try managedContext.save()
        //    contactDelegate?.didSuccessfullyCreateContact(contact: contact)
        //    self.dismiss(animated: true)
        //} catch let error as NSError {
        //    print("Coould not save. \(error), \(error.userInfo)")
        //}
    }
}

