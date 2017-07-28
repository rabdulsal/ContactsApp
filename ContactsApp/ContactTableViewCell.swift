//
//  ContactTableViewCell.swift
//  ContactsApp
//
//  Created by Rashad Abdul-Salaam on 7/26/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import UIKit

class ContactTableViewCell : UITableViewCell {
    
    
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    
    func configureContactCell(contact: Contact) {
        contactNameLabel.text = "\(contact.firstName!) \(contact.lastName!)"
        if let iData = contact.imageData {
            contactImageView.image = UIImage(data: iData)
        }
    }
}
