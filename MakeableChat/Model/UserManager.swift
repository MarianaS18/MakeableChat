//
//  UserManager.swift
//  MakeableChat
//
//  Created by Mariana Steblii on 06/04/2021.
//

import Foundation
import FirebaseAuth

protocol UserManagerDelegate {
    func didPassed()
    func didFailedWithError(error: String)
}

struct UserManager {
    
    var delegate: UserManagerDelegate?
    var dataManager = DataManager()
    let currentUser = Auth.auth().currentUser
    
    func login(_ email: String, _ password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error != nil {
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    self.delegate?.didFailedWithError(error: errorCode.errorMessage)
                }
            }
            else {
                self.delegate?.didPassed()
            }
        }
    }
    
    func register(_ username: String, _ email: String, _ password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    self.delegate?.didFailedWithError(error: errorCode.errorMessage)
                }
            }
            else {
                // add the new user to collection of users
                dataManager.addUser(username, email)
                delegate?.didPassed()
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            print("Error signing out, \(error)")
        }
    }
}

// MARK: - AuthErrorCode

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        
        // register errors
        case .emailAlreadyInUse:
            return "The email is already in use"
        case .invalidEmail, .invalidSender, .invalidRecipientEmail, .missingEmail:
            return "Please enter a valid email"
        case .weakPassword:
            return "Your password is too weak"
        
        // login errors
        case .wrongPassword:
            return "Password is wrong"
        case .userNotFound:
            return "User account was not found"
        
        // general errors
        case .networkError:
            return "Network error. Please try again."
        default:
            return "Unknown error occurred"
        }
    }
}
