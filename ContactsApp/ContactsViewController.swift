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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var noContactsView: UIView!
    
    var selectedContact: Contact?
    var allContacts = [Contact]()
    var contacts = [NSManagedObject]()
    var searchController: UISearchController!
    var filteredContacts = [Contact]()
    var coreContext = {
        return UIApplication.shared.delegate as? AppDelegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        contactsTableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if editingStyle == .delete {
            let contact = allContacts[indexPath.row]
            managedContext.delete(contact)
            appDelegate.saveContext()
            getData()
            contactsTableView.reloadData()
        }
    }
}

extension ContactsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchInProgress() ? filteredContacts.count : allContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCellID") as! ContactTableViewCell
        
        if searchInProgress() {
            let contact = filteredContacts[indexPath.row]
            cell.configureContactCell(contact: contact)
        } else {
            let contact = allContacts[indexPath.row]
            cell.configureContactCell(contact: contact)
        }
        return cell
    }
}

extension ContactsViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContents(of: searchController.searchBar.text!)
    }
}

extension ContactsViewController : ContactCreatable {
    func didSuccessfullyCreateContact(contact: Contact) {
        //selectedContact = contact
        noContactsView.isHidden = true
        getData()
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
        
        // SearchController
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        contactsTableView.tableHeaderView = self.searchController.searchBar
    }
    
    func getData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            allContacts = try managedContext.fetch(Contact.fetchRequest())
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func filterContents(of searchText: String) {
        self.filteredContacts = self.allContacts.filter { $0.firstName!.lowercased().contains(searchText.lowercased()) }
        contactsTableView.reloadData()
    }
    
    func searchInProgress() -> Bool {
        return searchController.isActive && searchController.searchBar.text?.isEmpty == false
    }
}

