//
//  EditContactViewController.swift
//  ContactsApp
//
//  Created by Rashad Abdul-Salaam on 7/26/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import UIKit

class EditContactViewController: UIViewController {
    
    // For creating new accounts and editing existing accounts

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pressedCancelButton(_ sender: Any) {
        // TODO: Alert requesting 'Are you sure'
        self.dismiss(animated: true)
    }
}

