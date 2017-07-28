//
//  UIButton+ContactApp.swift
//  ContactsApp
//
//  Created by Rashad Abdul-Salaam on 7/28/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import UIKit

class UpdateContactButton : UIButton {
    
    override var isEnabled: Bool {
        didSet {
            isEnabled ? setEnabledStyle() : setDisabledStyle()
        }
    }
    
    func setEnabledStyle() {
        titleLabel?.textColor = UIColor.white
        backgroundColor = UIColor.fusionGreen()
    }
    
    func setDisabledStyle() {
        titleLabel?.textColor = UIColor.darkGray
        backgroundColor = UIColor.lightGray
    }
}
