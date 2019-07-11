//
//  Item.swift
//  Todoey
//
//  Created by  oleg p on 10/07/2019.
//  Copyright © 2019  oleg p. All rights reserved.
//

import Foundation

class MyItem: Codable {
    var title = ""
    var done = false
    
    init(text: String) {
        title = text
    }
}
