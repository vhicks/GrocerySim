//
//  Register.swift
//  The Checkout
//
//  Created by Veronica Tatiana Hicks on 8/21/16.
//  Copyright © 2016 Mag and Co Brand. All rights reserved.
//

import Foundation

class Register {
    
    // MARK: - Properties
    var regNum: Int?
    var custList: [Customer]?
    var trainee: Bool
    var counter: Int?
    var occupied: Bool
    
    
    init(regNum: Int, trainee: Bool, counter: Int) {
        self.regNum = regNum
        self.custList = [Customer]()
        self.trainee = trainee
        self.counter = counter
        self.occupied = false
    }
    
    
    
}
