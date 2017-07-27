//
//  ContactService.swift
//  ContactsApp
//
//  Created by Rashad Abdul-Salaam on 7/27/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation

class ContactService {
    
    static func makePhoneNumber(with areacode: String, firstThreeDigits: String, lastFourDigits: String) -> String {
        
        return "(\(areacode)) \(firstThreeDigits)-\(lastFourDigits)"
    }
    
    static func makeBirthDate(with birthMonth: String, birthDay: String, birthYear: String) -> String {
        
        return "\(birthMonth)/\(birthDay)/\(birthYear)"
    }
}
