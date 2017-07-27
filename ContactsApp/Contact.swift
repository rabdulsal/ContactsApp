//
//  Contact.swift
//  ContactsApp
//
//  Created by Rashad Abdul-Salaam on 7/26/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import CoreData

class Contact : NSObject {
    
    var firstName: String
    var lastName: String
    var birthday: String // User helper method/class to construct bday from 3 separate strings
    var phone: String
    var zipcode: String
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    init(
        firstName: String,
        lastName: String,
        birthday: String,
        phone: String,
        zipcode: String)
    {
        self.firstName  = firstName
        self.lastName   = lastName
        self.birthday   = birthday
        self.phone      = phone
        self.zipcode    = zipcode
    }
}
