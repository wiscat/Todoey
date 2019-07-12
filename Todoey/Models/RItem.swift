//
//  RItem.swift
//  Todoey
//
//  Created by  oleg p on 12/07/2019.
//  Copyright © 2019  oleg p. All rights reserved.
//

import Foundation
import RealmSwift

class RItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    var parentCategory = LinkingObjects(fromType: RCategory.self, property: "items")
}

