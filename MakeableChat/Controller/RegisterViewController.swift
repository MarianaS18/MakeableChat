//
//  RegisterViewController.swift
//  MakeableChat
//
//  Created by Mariana Steblii on 06/04/2021.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    var userManager = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userManager.delegate = self
        
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self

        updateUI()
    }
    
    func updateUI() {
        registerButton.layer.cornerRadius = 8
        
        // TODO logo to the navigationbar
        // TODO textField color on dark mode
    }
 
    @IBAction func registerPressed(_ sender: UIButton) {
        if usernameTextField.text != "" {
            if let email = emailTextField.text, let password = passwordTextField.text {
                userManager.register(usernameTextField.text!, email, password)
            }
        }
        else {
            errorLabel.text = "You have to write a username"
        }
    }
    
}


// MARK: - UserManagerDelegate

extension RegisterViewController: UserManagerDelegate {
    
    func didPassed() {
        performSegue(withIdentifier: K.registerToChatSegue, sender: self)
    }
    
    func didFailedWithError(error: String) {
        errorLabel.text = error
    }
    
}


// MARK: - UITextFieldDelegate

extension RegisterViewController: UITextFieldDelegate {
    
    // jump to the next textField and hide the keyboard by the end
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            textField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
