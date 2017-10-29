//
//  extensions.swift
//  Routine
//
//  Created by Alex on 30.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation


extension String {
    
    // проверка на допустимость имен проекта и задачи
    var isValidForTitle: Bool {
        
        let latTextMask = "[A-Za-z0-9 -/:;()$&@'.,?! ]{4,32}"
//        let rusTextMask = "[А-Яа-я0-9.-.]{2,32}"
        let latTest = NSPredicate(format:"SELF MATCHES %@", latTextMask)
//        let rusTest = NSPredicate(format:"SELF MATCHES %@", rusTextMask)
        
        return latTest.evaluate(with: self) //|| rusTest.evaluate(with: self)
    }
 
}


