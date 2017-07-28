//
//  ContactViewController.swift
//  ContactsApp
//
//  Created by Rashad Abdul-Salaam on 7/26/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import UIKit

class ContactViewController : UIViewController {
    
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var zipcodeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var contact: Contact!
    var contactDelegate: ContactCreatable?
    var contactIdx: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decorateView(with: self.contact)
        
    }
    
    // MARK: IBAction
    
    @IBAction func pressedEditButton(_ sender: Any) {
        performSegue(withIdentifier: SegueIDs.editContact.rawValue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navVC = segue.destination as! UINavigationController
        let editContactVC = navVC.viewControllers.first as! EditContactViewController
        editContactVC.contactDelegate = self
        editContactVC.editingContact  = contact
        editContactVC.editingContactIdx = contactIdx
    }
    
}

extension ContactViewController : ContactCreatable {
    func didSuccessfullyCreateContact(contact: Contact) {
        decorateView(with: contact)
        contactDelegate?.didSuccessfullyCreateContact(contact: contact)
    }
    
    func didFailToCreateContact(error: NSError) {
        
    }
}

fileprivate extension ContactViewController {
    func decorateView(with contact: Contact) {
        contactNameLabel.text   = "\(contact.firstName!) \(contact.lastName!)"
        birthdayLabel.text      = contact.birthday
        phoneNumberLabel.text   = contact.phone
        zipcodeLabel.text       = contact.zipcode
        if let iData = contact.imageData {
            imageView.image = UIImage(data: iData)
        }
    }
}
