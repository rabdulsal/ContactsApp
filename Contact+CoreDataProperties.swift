//
//  Contact+CoreDataProperties.swift
//  ContactsApp
//
//  Created by Rashad Abdul-Salaam on 7/27/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var birthday: String?
    @NSManaged public var phoneDigits: String?
    @NSManaged public var formattedPhoneNumber: String?
    @NSManaged public var zipcode: String?
    @NSManaged public var imageData: Data?

}
