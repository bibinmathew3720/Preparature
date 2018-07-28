//
//  StringExtensions.swift
//  Baiger
//
//  Created by Albin Joseph on 12/5/17.
//  Copyright © 2017 Albin Joseph. All rights reserved.
//

import Foundation

extension String{
    
    func isPassowrdValid() -> Bool
    {
        let PASSREGEX = "[A-Za-z0-9._%!@#$%^&*_+|]{8,}"
        let passLength = NSPredicate(format: "SELF MATCHES %@",PASSREGEX)
        return passLength.evaluate(with:self)
    }
    
    func isvalidDOB()-> Bool{
        let DOBREGEX = "^\\d{1,2}\\-\\d{1,2}\\-\\d{4}$"
        let dob = NSPredicate(format: "SELF MATCHES %@",DOBREGEX)
        return dob.evaluate(with: self)
    }
    
    func isValidString() -> Bool {
        let str = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return str.isEmpty
    }
   
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isPhoneNumber() -> Bool {
        let PHONE_REGEX = "^\\d{8,12}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        return phoneTest.evaluate(with: self)
    }
    
}

