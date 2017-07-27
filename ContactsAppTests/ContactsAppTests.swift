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
    
    let firstName   = "Bob"
    let lastName    = "Loweth"
    let birthMo     = "01"
    let birthDay    = "01"
    let birthYr     = "1900"
    let areacode    = "312"
    let firstThree  = "123"
    let lastFour    = "4567"
    let zipcode     = "08003"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testContactConstructor() {
        
        let birthday = "01/01/1940"
        let phone = "(312) 123-4567"
        
        // When
        let contact = Contact(firstName: firstName, lastName: lastName, birthday: birthday, phone: phone, zipcode: zipcode)
        
        // Then
        XCTAssertTrue(contact.firstName == firstName, "FirstName should be \(firstName)")
        XCTAssertTrue(contact.lastName == lastName, "LastName should be \(lastName)")
        XCTAssertTrue(contact.birthday == birthday, "Birthday should be \(birthday)")
        XCTAssertTrue(contact.phone == phone, "Phone should be \(phone)")
        XCTAssertTrue(contact.zipcode == zipcode, "Zipcode should be \(zipcode)")
    }
    
    func testContactServiceBirthdayConstructor() {
        // Given
        
        
        // When
        let fullBirthDay = ContactService.makeBirthDate(with: birthMo, birthDay: birthDay, birthYear: birthYr)
        
        // Then
        XCTAssertTrue(fullBirthDay == "01/01/1900", "Birthday is \(fullBirthDay) it should be \(birthMo)/\(birthDay)/\(birthYr)")
    }
    
    func testContactServicePhoneNumberConstructor() {
        
        // When
        let fullPhone = ContactService.makePhoneNumber(with: areacode, firstThreeDigits: firstThree, lastFourDigits: lastFour)
        
        // Then
        XCTAssertTrue(fullPhone == "(312) 123-4567", "Phone number is \(fullPhone) it should be (\(areacode)) \(firstThree)-\(lastFour)")
    }
    
}
