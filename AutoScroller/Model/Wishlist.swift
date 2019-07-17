//
//  Wishlist.swift
//  AutoScroller
//
//  Created by Aria Bisma Wahyutama on 02/07/19.
//  Copyright © 2019 SHUBHAM AGARWAL. All rights reserved.
//

import Foundation
import RealmSwift

class Wishlist: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var price: String = ""
    @objc dynamic var category: String = ""
    @objc dynamic var icon: String = ""
    @objc dynamic var desc: String = ""
}
