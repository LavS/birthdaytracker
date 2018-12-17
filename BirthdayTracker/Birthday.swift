//
//  Birthday.swift
//  BirthdayTracker
//
//  Created by Sergey Lavrov on 16.12.2018.
//  Copyright © 2018 +1. All rights reserved.
//

import Foundation

class Birthday{
    let firstName: String
    let lastName: String
    let birthdate: Date
    
    init(firstName: String, lastName: String, birthdate: Date){
        self.firstName = firstName
        self.lastName = lastName
        self.birthdate = birthdate
    }
}
