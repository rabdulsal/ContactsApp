//
//  ContactService.swift
//  ContactsApp
//
//  Created by Rashad Abdul-Salaam on 7/27/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ContactService {
    
    static var appDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    static func makePhone(with areacode: String, firstThreeDigits: String, lastFourDigits: String) -> String {
        
        
        return "\(areacode)\(firstThreeDigits)\(lastFourDigits)"
    }
    
    static func makeFormattedPhoneNumber(with areacode: String, firstThreeDigits: String, lastFourDigits: String) -> String {
        
        return "(\(areacode)) \(firstThreeDigits)-\(lastFourDigits)"
    }
    
    static func makeBirthDate(with birthMonth: String, birthDay: String, birthYear: String) -> String {
        
        return "\(birthMonth)/\(birthDay)/\(birthYear)"
    }
    
    static func deconstructPhoneNumber(with phoneNumber: String) -> (String, String, String) {
        var areacode = ""
        var firstThreeDigits = ""
        var lastFourDigits = ""
        
        let subArry1 = phoneNumber.components(separatedBy: "-") // => [ "(312) 123", "4567" ]
        lastFourDigits = subArry1.last!
        let subStr1 = subArry1.first! // => "(312) 123"
        let subArry2 = subStr1.components(separatedBy: " ") // => [ "(312)", "123"]
        firstThreeDigits = subArry2.last!
        let subStr2 = subArry2.first! // => "(312)"
        let subArry3 = subStr2.components(separatedBy: "(") // => [ "(" , "312)" ]
        let subStr3 = subArry3.last! // => "312)"
        let subArry4 = subStr3.components(separatedBy: ")")
        areacode = subArry4.first!
        return (areacode, firstThreeDigits, lastFourDigits)
    }
    
    static func saveContact(with firstName: String, lastName: String, birthday: String, phone: String, formattedPhone: String, zipcode: String, imageData: Data?=nil, completion: ((_ contact: Contact)->Void)?=nil) {
        guard let appDelegate = ContactService.appDelegate else { return }
        
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
        if let _completion = completion {
            _completion(contact)
        }
    }
    
    static func updateContact(with editingContact: Contact, firstName: String, lastName: String, birthday: String, phone: String, formattedPhone: String, zipcode: String, imageData: Data?=nil, completion: ((_ contact: Contact)->Void)?=nil) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        var contacts = [Contact]()
        
        do {
            contacts = try managedContext.fetch(Contact.fetchRequest())
            // TODO: Make separate filter method
            let contact = contacts.filter {
                $0.firstName == editingContact.firstName &&
                    $0.lastName == editingContact.lastName &&
                    $0.birthday == editingContact.birthday &&
                    $0.phoneDigits == editingContact.phoneDigits &&
                    $0.zipcode == editingContact.zipcode
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
                if let _completion = completion {
                    _completion(c)
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
