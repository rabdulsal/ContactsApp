//
//  ContactsViewController.swift
//  ContactsApp
//
//  Created by Rashad Abdul-Salaam on 7/26/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import UIKit
import CoreData

enum SegueIDs : String {
    case contact = "GoToContact"
    case editContact = "GoToEditContact"
}

enum ViewControllerIDs : String {
    case contact = "ContactVCID"
    case editContact = "EditContactVCID"
}

class ContactsViewController: UIViewController {
    
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var noContactsView: UIView!
    
    var selectedContact: Contact?
    var allContacts = [Contact]()
    var contacts = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            contacts = try managedContext.fetch(fetchRequest)
            // TODO: Transform contacts<Array, NSManagedObject> in to allContacts<Array, Contact>
            allContacts = ContactService.makeContact(from: contacts)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let identifier = segue.identifier,
            let destination = SegueIDs.init(rawValue: identifier) else { return }
        
        switch destination {
        case .contact:
            let contactVC = segue.destination as! ContactViewController
            contactVC.contact = selectedContact
        case .editContact:
            let navVC = segue.destination as! UINavigationController
            let editContactVC = navVC.viewControllers.first as! EditContactViewController
            editContactVC.contactDelegate = self
        }
    }
    
    // MARK: IBActions
    
    @IBAction func pressedAddButton(_ sender: Any) {
        performSegue(withIdentifier: SegueIDs.editContact.rawValue, sender: nil)
    }
    

}

extension ContactsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedContact = allContacts[indexPath.row]
        performSegue(withIdentifier: SegueIDs.contact.rawValue, sender: nil)
    }
}

extension ContactsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let contact = allContacts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCellID") as! ContactTableViewCell
        cell.configureContactCell(contact: contact)
        return cell
    }
}

extension ContactsViewController : ContactCreatable {
    func didSuccessfullyCreateContact(contact: Contact) {
        selectedContact = contact
        allContacts.append(selectedContact!)
        noContactsView.isHidden = true
        contactsTableView.reloadData()
    }
    
    func didFailToCreateContact(error: NSError) {
        print(error.localizedDescription)
    }
}

fileprivate extension ContactsViewController {
    
    func setup() {
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        noContactsView.isHidden = false
    }
}

