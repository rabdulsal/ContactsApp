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
    @IBOutlet weak var noContactsViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var noContactsLabel: UILabel!
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
        toggleNoContactsView()
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
            navVC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
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
            toggleNoContactsView()
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
        getData()
        contactsTableView.reloadData()
        toggleNoContactsView()
    }
    
    func didFailToCreateContact(error: NSError) {
        print(error.localizedDescription)
    }
}

fileprivate extension ContactsViewController {
    
    func setup() {
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        contactsTableView.tableHeaderView = self.searchController.searchBar
        contactsTableView.tableFooterView = UIView()
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
    
    func toggleNoContactsView() {
        allContacts.isEmpty ? showNoContactsView() : hideNoContactsView()
    }
    
    func showNoContactsView() {
        noContactsView.isHidden = false
        noContactsViewHeightConstraint.constant = 100
        noContactsLabel.isHidden = false
    }
    
    func hideNoContactsView() {
//        noContactsView.isHidden = true
        noContactsViewHeightConstraint.constant = 0
        noContactsLabel.isHidden = true
    }
}

