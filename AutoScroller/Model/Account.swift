//
//  Account.swift
//  AutoScroller
//
//  Created by Aria Bisma Wahyutama on 12/07/19.
//  Copyright © 2019 ARIA BISMA WAHYUTAMA. All rights reserved.
//

import Foundation
import RealmSwift

class Account: Object {
    @objc dynamic var fullName: String = ""
    @objc dynamic var phoneNumber: String = ""
    @objc dynamic var username: String = ""
    @objc dynamic var password: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var gender: String = ""
    
}

