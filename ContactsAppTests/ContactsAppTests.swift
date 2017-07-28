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
    
    let firstName   = "Max"
    let lastName    = "Paltsev"
    let birthMo     = "09"
    let birthDay    = "01"
    let birthYr     = "2013"
    let areacode    = "888"
    let firstThree  = "903"
    let lastFour    = "0304"
    let zipcode     = "76034"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testContactServiceBirthdayConstructor() {
        // Given Scaffold
        
        // When
        let fullBirthDay = ContactService.makeBirthDate(with: birthMo, birthDay: birthDay, birthYear: birthYr)
        
        // Then
        XCTAssertTrue(fullBirthDay == "09/01/2013", "Birthday is \(fullBirthDay) it should be \(birthMo)/\(birthDay)/\(birthYr)")
    }
    
    func testContactServiceFormattedPhoneNumberConstructor() {
        // Given Scaffold
        
        // When
        let fullPhone = ContactService.makeFormattedPhoneNumber(with: areacode, firstThreeDigits: firstThree, lastFourDigits: lastFour)
        
        // Then
        XCTAssertTrue(fullPhone == "(888) 903-0304", "Phone number is \(fullPhone) it should be (\(areacode)) \(firstThree)-\(lastFour)")
    }
    
    func testContactServicePhoneDeconstructor() {
        let phone = "(312) 123-4567"
        let phoneTuple: (String, String, String) = ContactService.deconstructPhoneNumber(with: phone)
        
        XCTAssertTrue(phoneTuple.0 == "312" && phoneTuple.1 == "123" && phoneTuple.2 == "4567", "Deconstruction \(phoneTuple) is wrong")
        
    }
    
}
