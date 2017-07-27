//
//  ContactService.swift
//  ContactsApp
//
//  Created by Rashad Abdul-Salaam on 7/27/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import CoreData

class ContactService {
    
    enum PropertyKeys : String {
        case firstName = "firstName"
        case lastName = "lastName"
        case birthday = "birthday"
        case phone = "phone"
        case zipcode = "zipcode"
    }
    
    static func makePhoneNumber(with areacode: String, firstThreeDigits: String, lastFourDigits: String) -> String {
        
        return "(\(areacode)) \(firstThreeDigits)-\(lastFourDigits)"
    }
    
    static func makeBirthDate(with birthMonth: String, birthDay: String, birthYear: String) -> String {
        
        return "\(birthMonth)/\(birthDay)/\(birthYear)"
    }
    
    static func makeContact(from managedObjects: [NSManagedObject]) -> [Contact] {
        var contacts = [Contact]()
        for object in managedObjects {
            if
                let fName = object.value(forKey: PropertyKeys.firstName.rawValue) as? String,
                let lName = object.value(forKey: PropertyKeys.lastName.rawValue) as? String,
                let bday = object.value(forKey: PropertyKeys.birthday.rawValue) as? String,
                let phone = object.value(forKey: PropertyKeys.phone.rawValue) as? String,
                let zip = object.value(forKey: PropertyKeys.zipcode.rawValue) as? String
            {
            let contact = Contact(
                firstName: fName,
                lastName: lName,
                birthday: bday,
                phone: phone,
                zipcode: zip)
                contacts.append(contact)
            }
        }
        return contacts
    }
}
