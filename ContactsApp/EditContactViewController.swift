//
//  EditContactViewController.swift
//  ContactsApp
//
//  Created by Rashad Abdul-Salaam on 7/26/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import UIKit
import CoreData



protocol ContactCreatable {
    func didSuccessfullyCreateContact(contact: Contact)
    func didFailToCreateContact(error: NSError)
}

class EditContactViewController: UIViewController {
    
    enum TextfieldType : Int {
        case firstName = 0
        case lastName
        case birthday
        case areacode
        case firstThree
        case lastFour
        case zipcode
    }
    // For creating new accounts and editing existing accounts
    
    // Name & zip fields
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var zipcodeField: UITextField!
    @IBOutlet weak var birthYearField: UITextField!
    
    // Phone number fields
    @IBOutlet weak var areacodeField: UITextField!
    @IBOutlet weak var threeDigitField: UITextField!
    @IBOutlet weak var fourDigitField: UITextField!
    
    @IBOutlet weak var updateContactButton: UpdateContactButton!
    
    var contactDelegate: ContactCreatable?
    var editingContact: Contact?
    var editingContactIdx: Int?
    var activeTextfield: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        verifyFields()
    }
    
    override func doneButtonPressed(_ sender: Any) {
        //        if let textField = birthYearField {
        //            // TODO: Refactor to method
        //            let nextTag: NSInteger = textField.tag + 1;
        //            // Try to find next responder
        //            if let nextResponder: UIResponder = textField.superview!.viewWithTag(nextTag) {//could not find an overload for '!=' that accepts the supplied arguments
        //
        //                // Found next responder, so set it.
        //                nextResponder.becomeFirstResponder()
        //            } else {
        //                // Not found, so remove keyboard.
        //                textField.resignFirstResponder()
        //            }
        //        }
        advanceTextfields()
    }
    
    override func dateChanged(_ datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        activeTextfield = birthYearField
        self.birthYearField.text = formatter.string(from: datePicker.date)
        print("Date:",birthYearField.text!)
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
            let zipcode = zipcodeField.text,
            let birthday = birthYearField.text else
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
        
        
        let phone = ContactService.makePhoneNumber(with: areacode, firstThreeDigits: threeDigit, lastFourDigits: fourDigit)
        //let contact = Contact(firstName: firstName, lastName: lastName, birthday: birthday, phone: phone, zipcode: zipcode)
        if let _ = editingContact {
            updateContact(with: firstName, lastName: lastName, birthday: birthday, phone: phone, zipcode: zipcode)
        } else {
            saveContact(with: firstName, lastName: lastName, birthday: birthday, phone: phone, zipcode: zipcode)
        }
    }
}

extension EditContactViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var maxAllowableCharacters: Int
        var autoAdvance: Bool
        
        switch TextfieldType(rawValue: textField.tag)! {
        case .areacode:
            maxAllowableCharacters = 3
            autoAdvance = true
        case .firstThree:
            maxAllowableCharacters = 3
            autoAdvance = true
        case .lastFour:
            maxAllowableCharacters = 4
            autoAdvance = true
        case .zipcode:
            maxAllowableCharacters = 5
            autoAdvance = false
        default:
            maxAllowableCharacters = 100
            autoAdvance = false
        }
        
        if let text = textField.text {
            if range.length + range.location > text.characters.count {
                return false
            }
            
            let textLength = text.characters.count + string.characters.count - range.length
            if textLength > maxAllowableCharacters {
                if autoAdvance { advanceTextfields() }
                return false
            } else {
                textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                return true
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextfield = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        let nextTag: NSInteger = activeTextfield!.tag + 1;
//        // Try to find next responder
//        if let nextResponder: UIResponder = textField.superview!.viewWithTag(nextTag) {
//            
//            // Found next responder, so set it.
//            nextResponder.becomeFirstResponder()
//        } else {
//            // Not found, so remove keyboard.
//            textField.resignFirstResponder()
//        }
        advanceTextfields()
        return false; // We do not want UITextField to insert line-breaks.
    }
}

fileprivate extension EditContactViewController {
    func setup() {
        if let contact = editingContact {
            decorateTextfields(with: contact)
        }
        initializeTextFieldInputView()
        firstNameField.tag = TextfieldType.firstName.rawValue
        firstNameField.delegate = self
        firstNameField.inputAccessoryView = makeDoneButtonToolBar()
        lastNameField.tag = TextfieldType.lastName.rawValue
        lastNameField.delegate = self
        lastNameField.inputAccessoryView = makeDoneButtonToolBar()
        birthYearField.tag = TextfieldType.birthday.rawValue
        birthYearField.inputAccessoryView = makeDoneButtonToolBar()
        areacodeField.tag = TextfieldType.areacode.rawValue
        areacodeField.keyboardType = .phonePad
        areacodeField.delegate = self
        areacodeField.inputAccessoryView = makeDoneButtonToolBar()
        threeDigitField.tag = TextfieldType.firstThree.rawValue
        threeDigitField.delegate = self
        threeDigitField.keyboardType = .phonePad
        threeDigitField.inputAccessoryView = makeDoneButtonToolBar()
        fourDigitField.tag = TextfieldType.lastFour.rawValue
        fourDigitField.delegate = self
        fourDigitField.inputAccessoryView = makeDoneButtonToolBar()
        fourDigitField.keyboardType = .phonePad
        zipcodeField.tag = TextfieldType.zipcode.rawValue
        zipcodeField.keyboardType = .phonePad
        zipcodeField.delegate = self
        zipcodeField.inputAccessoryView = makeDoneButtonToolBar()
    }
    
    func decorateTextfields(with contact: Contact) {
        firstNameField.text = contact.firstName
        lastNameField.text  = contact.lastName
        zipcodeField.text   = contact.zipcode
        
        
        //birthMonthField: UITextField!
       // birthDateField: UITextField!
        //birthYearField: UITextField!
        
        
//        areacodeField.text  = contact.areacode
//        threeDigitField: UITextField!
//        fourDigitField: UITextField!
    }
    
    func initializeTextFieldInputView() {
        // Add date picker
//        let datePicker = UIDatePicker()
//        var components = DateComponents()
//        components.year = -100
//        let minDate = Calendar.current.date(byAdding: components, to: Date())
//        
//        components.year = -18
//        let maxDate = Calendar.current.date(byAdding: components, to: Date())
//        
//        datePicker.minimumDate = minDate
//        datePicker.maximumDate = maxDate
//        datePicker.datePickerMode = .date
//        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        self.birthYearField.inputView = makeDatePickerView()
        
        // TODO: Refactor
//        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
//        let flexibleSeparator = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed(_:)))
//        toolbar.items = [flexibleSeparator, doneButton]
//        self.birthYearField.inputAccessoryView = toolbar
    }
    
    
    
    @objc func textFieldDidChange(_ sender: Any) {
        verifyFields()
    }
    
    
    func advanceTextfields() {
        let nextTag: NSInteger = activeTextfield!.tag + 1;
        // Try to find next responder
        if let nextResponder: UIResponder = activeTextfield!.superview!.viewWithTag(nextTag) {
            
            // Found next responder, so set it.
            nextResponder.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            activeTextfield!.resignFirstResponder()
        }

    }
    
    func allFieldsComplete() -> Bool {
        return firstNameField.text?.isEmpty == false &&
            lastNameField.text?.isEmpty == false &&
            birthYearField.text?.isEmpty == false &&
            areacodeField.text?.isEmpty == false &&
            threeDigitField.text?.isEmpty == false &&
            fourDigitField.text?.isEmpty == false &&
            zipcodeField.text?.isEmpty == false
        
    }
    
    func verifyFields() {
        updateContactButton.isEnabled = allFieldsComplete()
    }
    
    // TODO: Move to ContactService
    
    func updateContact(with firstName: String, lastName: String, birthday: String, phone: String, zipcode: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        var contacts = [Contact]()
        //let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            contacts = try managedContext.fetch(Contact.fetchRequest())
            // TODO: Make separate filter method
            let contact = contacts.filter {
                $0.firstName == self.editingContact!.firstName &&
                $0.lastName == self.editingContact!.lastName &&
                //$0.birthday == birthday &&
                //$0.phone == phone &&
                $0.zipcode == self.editingContact!.zipcode
            }.first
            if let c = contact {
                // TODO: Createnew Save func from here
                c.firstName = firstName
                c.lastName = lastName
                c.birthday = birthday
                c.phone = phone
                c.zipcode = zipcode
                appDelegate.saveContext()
                contactDelegate?.didSuccessfullyCreateContact(contact: c)
                self.dismiss(animated: true)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func saveContact(with firstName: String, lastName: String, birthday: String, phone: String, zipcode: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let contact = Contact(context: managedContext)
        // TODO: Create new save func from here
        contact.firstName = firstName
        contact.lastName = lastName
        contact.birthday = birthday
        contact.phone = phone
        contact.zipcode = zipcode
        appDelegate.saveContext()
        contactDelegate?.didSuccessfullyCreateContact(contact: contact)
        self.dismiss(animated: true)
    }
}

