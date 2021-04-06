//
//  ViewController.swift
//  MakeableChat
//
//  Created by Mariana Steblii on 06/04/2021.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var userManager = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userManager.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    func updateUI() {
        loginButton.layer.cornerRadius = 8
        registerButton.layer.cornerRadius = 8
        
        // TODO change textField from black color to white in dark mode
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            userManager.login(email, password)
        }
    }
}

// MARK: - UserManagerDelegate

extension LoginViewController: UserManagerDelegate {
    
    // navigate to chat
    func didPassed() {
        DispatchQueue.main.async {
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            self.performSegue(withIdentifier: K.loginToChatSegue, sender: self)
        }
    }
    
    func didFailedWithError(error: String) {
        errorLabel.text = error
    }
    
}


// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    // jump to the next textField and hide the keyboard by the end
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
