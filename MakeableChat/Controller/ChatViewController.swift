//
//  ChatViewController.swift
//  MakeableChat
//
//  Created by Mariana Steblii on 06/04/2021.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    
    var userManager = UserManager()
    var dataManager = DataManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        messageTextField.delegate = self
        dataManager.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        updateUI()
        dataManager.loadMessages()
    }
    
    func updateUI() {
        navigationItem.hidesBackButton = true
        
        UIController.textFileldUpdate(textField: messageTextField, placeholder: "")
        
        self.navigationItem.titleView = UIController.setLogo()
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        userManager.logout()
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        let email = userManager.currentUser?.email
        dataManager.getUsername(with: email!)
    }
    
}


// MARK: - UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        
        let currentMessage = dataManager.messages[indexPath.row]
        cell.messageLabel.text = currentMessage.message
        cell.nameLabel.text = currentMessage.username
        cell.timeLabel.text = currentMessage.time
        
        // current user
        if currentMessage.email == userManager.currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageView.backgroundColor = UIColor(named: K.Color.lightBlue)
            cell.nameLabel.textAlignment = .right
            cell.timeLabel.textAlignment = .right
        }
        
        // another users
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageView.backgroundColor = UIColor(named: K.Color.lightGrey)
            cell.nameLabel.textAlignment = .left
            cell.timeLabel.textAlignment = .left
        }
        
        // all users
        cell.messageLabel.textColor = UIColor(named: K.Color.black)
        cell.nameLabel.textColor = UIColor(named: K.Color.grey)
        cell.timeLabel.textColor = UIColor(named: K.Color.grey)

        
        return cell
    }
    
}


// MARK: - UITextFieldDelegate

extension ChatViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

// MARK: - DataManagerDelegate

extension ChatViewController: DataManagerDelegate {
    
    func didPassed() {
        DispatchQueue.main.async {
            self.messageTextField.text = ""
        }
    }
    
    func createMessageObject(with username: String) {
        let email = userManager.currentUser?.email
        
        let curentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        let time = formatter.string(from: curentDateTime)
        
        if messageTextField.text != "" {
            dataManager.sendMessage(username, email!, time, messageTextField.text!)
        }
    }
    
    func didGetData() {
        DispatchQueue.main.async {
            self.chatTableView.reloadData()
            let indexPath = IndexPath(row: self.dataManager.messages.count - 1, section: 0)
            self.chatTableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
    
}
