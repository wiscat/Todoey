//
//  RCategory.swift
//  Todoey
//
//  Created by  oleg p on 12/07/2019.
//  Copyright © 2019  oleg p. All rights reserved.
//

import Foundation
import RealmSwift

class RCategory: Object {
    @objc dynamic var name: String = ""
    
    let items = List<RItem>()
}
