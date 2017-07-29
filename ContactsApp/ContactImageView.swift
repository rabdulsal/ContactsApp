//
//  ContactImageView.swift
//  ContactsApp
//
//  Created by Rashad Abdul-Salaam on 7/28/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import UIKit

class ContactImageView : UIImageView {
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.contentMode = .scaleAspectFill
    }
    
    func roundedCorners() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
    func boxedCorners() {
        self.layer.cornerRadius = 0
        self.clipsToBounds = false
    }
}
