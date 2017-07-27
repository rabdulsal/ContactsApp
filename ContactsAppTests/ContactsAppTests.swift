//
//  ContactsAppTests.swift
//  ContactsAppTests
//
//  Created by Rashad Abdul-Salaam on 7/26/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import XCTest
@testable import ContactsApp

class ContactsAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testContactConstructor() {
        // Given
        let firstName = "Bob"
        let lastName  = "Loweth"
        let birthday  = "03/17/1940"
        let phone     = "(312) 369-9850"
        let zipcode   = "08003"
        
        // When
        let contact = Contact(firstName: firstName, lastName: lastName, birthday: birthday, phone: phone, zipcode: zipcode)
        
        // Then
        XCTAssertTrue(contact.firstName == firstName, "FirstName should be \(firstName)")
        XCTAssertTrue(contact.lastName == lastName, "LastName should be \(lastName)")
        XCTAssertTrue(contact.birthday == birthday, "Birthday should be \(birthday)")
        XCTAssertTrue(contact.phone == phone, "Phone should be \(phone)")
        XCTAssertTrue(contact.zipcode == zipcode, "Zipcode should be \(zipcode)")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
