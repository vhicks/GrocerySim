//
//  Customer.swift
//  The Checkout
//
//  Created by Veronica Tatiana Hicks on 8/21/16.
//  Copyright © 2016 Mag and Co Brand. All rights reserved.
//

import Foundation

class Customer {
    
    // MARK: - Properties
    var items: Int?
    var type: String?
    var arrival: Int?
    var registerAssignment: Int?
    
    init(items: Int, type: String, arrival: Int, registerAssignment: Int) {
        self.items = items
        self.type = type
        self.arrival = arrival
        self.registerAssignment = registerAssignment
    }
    
    
    
}
