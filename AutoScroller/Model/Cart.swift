//
//  Cart.swift
//  AutoScroller
//
//  Created by Aria Bisma Wahyutama on 11/07/19.
//  Copyright © 2019 ARIA BISMA WAHYUTAMA. All rights reserved.

import Foundation
import RealmSwift

class Cart: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var price: String = ""
    @objc dynamic var category: String = ""
    @objc dynamic var icon: String = ""
    @objc dynamic var poster1: String = ""
    @objc dynamic var poster2: String = ""
    @objc dynamic var poster3: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var account: String = ""
}
