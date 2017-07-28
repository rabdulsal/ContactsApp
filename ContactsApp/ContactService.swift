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
}
