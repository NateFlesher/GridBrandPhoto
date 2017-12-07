//
//  GridbrandProtocol.swift
//  gridbrand
//
//  Created by LionStar on 1/8/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ValidationResult {
    case ok(message: String)
    case empty
    case validating
    case failed(message: String)
}

enum SignupState {
    case signedUp(signedUp: Bool)
}

protocol GridbrandAPI {
    func emailAvailable(_ email: String) -> Observable<Bool>
    func signup(data: SignupModel) -> Observable<UserModel>
}

protocol GridbrandValidationService {
    func validateEmail(_ email: String) -> Observable<ValidationResult>
    func validateFullname(_ fullname: String) -> ValidationResult
    func validatePassword(_ password: String) -> ValidationResult
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

