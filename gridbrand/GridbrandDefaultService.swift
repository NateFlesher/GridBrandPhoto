//
//  GridbrandDefaultService.swift
//  gridbrand
//
//  Created by LionStar on 1/8/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation
import RxSwift

class GridbrandDefaultValidationService: GridbrandValidationService {
    let API: GridbrandAPI
    
    static let sharedValidationService = GridbrandDefaultValidationService(API: GridbrandDefaultAPI.sharedAPI)
    
    init (API: GridbrandAPI) {
        self.API = API
    }
    
    // validation
    
    let minPasswordCount = 5
    
    func validateEmail(_ email: String) -> Observable<ValidationResult> {
        if email.characters.count == 0 {
            return .just(.empty)
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if !emailTest.evaluate(with: email) {
            return .just(.failed(message: "No valid email format"))
        }
        
        let loadingValue = ValidationResult.validating
        
        return API
            .emailAvailable(email)
            .map { available in
                if available {
                    return .ok(message: "Email available")
                }
                else {
                    return .failed(message: "Email already taken")
                }
            }
            .startWith(loadingValue)
    }
    
    func validateFullname(_ fullname: String) -> ValidationResult {
        if fullname.characters.count == 0 {
            return .empty
        }        
        
        return .ok(message: "Fullname is valid")
    }
    
    func validatePassword(_ password: String) -> ValidationResult {
        let numberOfCharacters = password.characters.count
        if numberOfCharacters == 0 {
            return .empty
        }
        
        if numberOfCharacters < minPasswordCount {
            return .failed(message: "Password must be at least \(minPasswordCount) characters")
        }
        
        return .ok(message: "Password acceptable")
    }
    
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult {
        if repeatedPassword.characters.count == 0 {
            return .empty
        }
        
        if repeatedPassword == password {
            return .ok(message: "Password repeated")
        }
        else {
            return .failed(message: "Password different")
        }
    }
}
