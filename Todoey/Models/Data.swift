//
//  Data.swift
//  Todoey
//
//  Created by  oleg p on 11/07/2019.
//  Copyright © 2019  oleg p. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
