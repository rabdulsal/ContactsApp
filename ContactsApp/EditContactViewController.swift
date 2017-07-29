//
//  EditContactViewController.swift
//  ContactsApp
//
//  Created by Rashad Abdul-Salaam on 7/26/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices
import AVFoundation
import Photos

protocol ContactCreatable {
    func didSuccessfullyCreateContact(contact: Contact)
    func didFailToCreateContact(error: NSError)
}

class EditContactViewController: UIViewController {
    
    static let formatter = DateFormatter()
    
    enum TextfieldType : Int {
        case firstName = 0
        case lastName
        case birthday
        case areacode
        case firstThree
        case lastFour
        case zipcode
    }
    
    // Name & zip fields
    @IBOutlet weak var firstNameField: ContactTextField!
    @IBOutlet weak var lastNameField: ContactTextField!
    @IBOutlet weak var zipcodeField: ContactTextField!
    @IBOutlet weak var birthYearField: ContactTextField!
    
    // Phone number fields
    @IBOutlet weak var areacodeField: ContactTextField!
    @IBOutlet weak var threeDigitField: ContactTextField!
    @IBOutlet weak var fourDigitField: ContactTextField!
    
    @IBOutlet weak var updateContactButton: UpdateContactButton!
    @IBOutlet weak var imageView: ContactImageView!
    @IBOutlet weak var cameraTriggerButton: UIButton!
    
    var contactDelegate: ContactCreatable?
    var editingContact: Contact?
    var editingContactIdx: Int?
    var activeTextfield: UITextField?
    fileprivate let kMaxMomentImageSize = 340000.0
    fileprivate var imageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        verifyFields()
        if imageView.image == nil {
            cameraTriggerButton.setTitle("Add Photo", for: .normal)
            imageView.backgroundColor = UIColor.lightGray
            imageView.boxedCorners()
        } else {
            setImageViewEditStyle()
        }
    }
    
    override func doneButtonPressed(_ sender: Any) {
        advanceTextfields()
    }
    
    override func dateChanged(_ datePicker: UIDatePicker) {
        EditContactViewController.formatter.dateFormat = "MM/dd/yyyy"
        activeTextfield = birthYearField
        self.birthYearField.text = EditContactViewController.formatter.string(from: datePicker.date)
    }
    
    // MARK: IBActions

    @IBAction func pressedCancelButton(_ sender: Any) {
        // TODO: Alert requesting 'Are you sure'
        self.dismiss(animated: true)
    }
    
    @IBAction func pressedUpdateContactButton(_ sender: Any) {
        
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
        
        
        let formattedPhone = ContactService.makeFormattedPhoneNumber(with: areacode, firstThreeDigits: threeDigit, lastFourDigits: fourDigit)
        let unformattedPhone = ContactService.makePhone(with: areacode, firstThreeDigits: threeDigit, lastFourDigits: fourDigit)
        if let _ = editingContact {
            updateContact(with: firstName, lastName: lastName, birthday: birthday, phone: unformattedPhone, formattedPhone: formattedPhone, zipcode: zipcode, imageData: self.imageData)
        } else {
            saveContact(with: firstName, lastName: lastName, birthday: birthday, phone: unformattedPhone, formattedPhone: formattedPhone, zipcode: zipcode, imageData: self.imageData)
        }
    }
    
    @IBAction func pressedCameraTriggerButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            shootPhoto()
        } else {
            accessPhotos()
        }
    }
    
}

// MARK: TextFieldDelegate 

extension EditContactViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let tField = textField as! ContactTextField
        var autoAdvance: Bool
        
        switch TextfieldType(rawValue: textField.tag)! {
        case .areacode, .firstThree, .lastFour: autoAdvance = true
        default: autoAdvance = false
        }
        
        if let text = textField.text {
            if range.length + range.location > text.characters.count {
                return false
            }
            
            let textLength = text.characters.count + string.characters.count - range.length
            if textLength > tField.maxAllowableCharacters {
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
        switch TextfieldType(rawValue: textField.tag)! {
        case .zipcode:
            
            pressedUpdateContactButton(self)
        default: advanceTextfields()
            
        }
        return false
    }
}

// MARK: ImagePickerDelegate

extension EditContactViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = chosenImage
        imageData = UIImageJPEGRepresentation(chosenImage, 0.0)
        setImageViewEditStyle()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

fileprivate extension EditContactViewController {
    func setup() {
        if let contact = editingContact {
            decorateTextfields(with: contact)
        }
        configureTextFieldViews()
        
    }
    
    // MARK: TextField Stuff
    
    func decorateTextfields(with contact: Contact) {
        firstNameField.text = contact.firstName
        lastNameField.text  = contact.lastName
        zipcodeField.text   = contact.zipcode
        birthYearField.text = contact.birthday
        if let iData = contact.imageData {
            imageView.image = UIImage(data: iData)
        }
        (areacodeField.text!, threeDigitField.text!, fourDigitField.text!) = ContactService.deconstructPhoneNumber(with: contact.formattedPhoneNumber!)
    }
    
    func setImageViewEditStyle() {
        cameraTriggerButton.setTitle("Edit", for: .normal)
        cameraTriggerButton.tintColor = UIColor.white
        imageView.backgroundColor = UIColor.white
        imageView.roundedCorners()
    }
    
    func configureTextFieldViews() {
        let datePickerView = makeDatePickerView()
        let accessoryView = makeDoneButtonToolBar()
        firstNameField.configureTextField(with: self, tag: TextfieldType.firstName.rawValue, accessoryView: accessoryView)
        lastNameField.configureTextField(with: self, tag: TextfieldType.lastName.rawValue, accessoryView: accessoryView)
        birthYearField.configureTextField(with: self, tag: TextfieldType.birthday.rawValue, inputView: datePickerView, accessoryView: accessoryView)
        areacodeField.configureTextField(with: self, tag: TextfieldType.areacode.rawValue, keyboardType: .phonePad, accessoryView: accessoryView, maxCharacters: 3)
        threeDigitField.configureTextField(with: self, tag: TextfieldType.firstThree.rawValue, keyboardType: .phonePad, accessoryView: accessoryView, maxCharacters: 3)
        fourDigitField.configureTextField(with: self, tag: TextfieldType.lastFour.rawValue, keyboardType: .phonePad, accessoryView: accessoryView, maxCharacters: 4)
        zipcodeField.configureTextField(with: self, tag: TextfieldType.zipcode.rawValue, returnKey: .done, keyboardType: .numberPad, accessoryView: accessoryView, maxCharacters: 5)
    }
    
    @objc func textFieldDidChange(_ sender: Any) {
        verifyFields()
    }
    
    
    func advanceTextfields() {
        let nextTag: NSInteger = activeTextfield!.tag + 1
        if let nextResponder: UIResponder = activeTextfield!.superview!.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            activeTextfield!.resignFirstResponder()
        }

    }
    
    func allFieldsComplete() -> Bool {
        return firstNameField.text?.isEmpty == false &&
            lastNameField.text?.isEmpty == false &&
            birthYearField.text?.isEmpty == false &&
            areacodeField.isValidlyComplete &&
            threeDigitField.isValidlyComplete &&
            fourDigitField.isValidlyComplete &&
            zipcodeField.isValidlyComplete
        
    }
    
    func verifyFields() {
        updateContactButton.isEnabled = allFieldsComplete()
    }
    
    // MARK: Camera Stuff
    func prepareImage(inputImage: UIImage) -> UIImage {
        var outputImage = inputImage
        // If the UIImage is larger than kMaxMomentImageSize, scale it down
        let imageSize = UIImageJPEGRepresentation(inputImage, 0)!.count
        var scale = 1.0
        
        if (Double(imageSize) > kMaxMomentImageSize) {
            if let image = UIImage(data: UIImageJPEGRepresentation(inputImage, 0)!) {
                scale = kMaxMomentImageSize / Double(imageSize)
                let size = CGSize(width: image.size.width * CGFloat(scale), height: image.size.height * CGFloat(scale))
                
                UIGraphicsBeginImageContext(size)
                image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                outputImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
            }
        } else {
            return outputImage
        }
        
        return outputImage
    }
    
    func shootPhoto() {
        let imagePicker           = UIImagePickerController()
        imagePicker.delegate      = self
        imagePicker.sourceType    = .camera
        imagePicker.allowsEditing = false // Maybe turn to true if have time
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func accessPhotos() {
        let imagePicker           = UIImagePickerController()
        imagePicker.delegate      = self
        imagePicker.sourceType    = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.modalPresentationStyle = .popover
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // TODO: Move to ContactService
    
    func updateContact(with firstName: String, lastName: String, birthday: String, phone: String, formattedPhone: String, zipcode: String, imageData: Data?=nil) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        var contacts = [Contact]()
        
        do {
            contacts = try managedContext.fetch(Contact.fetchRequest())
            // TODO: Make separate filter method
            let contact = contacts.filter {
                $0.firstName == self.editingContact!.firstName &&
                $0.lastName == self.editingContact!.lastName &&
                $0.birthday == self.editingContact!.birthday &&
                $0.phoneDigits == self.editingContact!.phoneDigits &&
                $0.zipcode == self.editingContact!.zipcode
            }.first
            if let c = contact {
                // TODO: Createnew Save func from here
                c.firstName = firstName
                c.lastName = lastName
                c.birthday = birthday
                c.phoneDigits = phone
                c.zipcode = zipcode
                c.formattedPhoneNumber = formattedPhone
                if let iData = imageData {
                    c.imageData = iData
                }
                appDelegate.saveContext()
                contactDelegate?.didSuccessfullyCreateContact(contact: c)
                self.dismiss(animated: true)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func saveContact(with firstName: String, lastName: String, birthday: String, phone: String, formattedPhone: String, zipcode: String, imageData: Data?=nil) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let contact = Contact(context: managedContext)
        // TODO: Create new save func from here
        contact.firstName = firstName
        contact.lastName = lastName
        contact.birthday = birthday
        contact.phoneDigits = phone
        contact.formattedPhoneNumber = formattedPhone
        contact.zipcode = zipcode
        if let iData = imageData {
            contact.imageData = iData
        }
        appDelegate.saveContext()
        contactDelegate?.didSuccessfullyCreateContact(contact: contact)
        self.dismiss(animated: true)
    }
}

