//
//  DataManager.swift
//  MakeableChat
//
//  Created by Mariana Steblii on 06/04/2021.
//

import Foundation
import Firebase

protocol DataManagerDelegate {
    func didGetData()
    func createMessageObject(with username: String)
    func didPassed()
}

class  DataManager {
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    var delegate: DataManagerDelegate?
    
    // add new user to collection of users
    func addUser(_ username: String, _ email: String) {
        db.collection(K.FB.userCollection).addDocument(data: [
            "username": username,
            "email": email
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added")
            }
        }
    }
 
    // get all messages from collection
    func  loadMessages() {
        db.collection(K.FB.messageCollection)
            .order(by: K.FB.orderField)
            .addSnapshotListener { (querySnapshot, error) in
                self.messages = []
                
                if let error = error {
                    print("Error retrieving data from firestore, \(error)")
                }
                else {
                    if let snapshotDocs = querySnapshot?.documents {
                        for doc in snapshotDocs {
                            let data = doc.data()
                            if let email = data[K.FB.emailField] as? String,
                               let message = data[K.FB.messageField] as? String,
                               let time = data[K.FB.timeField] as? String,
                               let username = data[K.FB.usernameField] as? String {
                                self.messages.append(Message(username: username, email: email, message: message, time: time))
                                
                                self.delegate?.didGetData()
                            }
                        }
                    }
                }
            }
    }
    
    // get username with email
    func  getUsername(with email: String) {
        var username: String?
        db.collection(K.FB.userCollection).whereField(K.FB.emailField, isEqualTo: email).getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            }
            else {
                for document in querySnapshot!.documents {
                    username = (document.get(K.FB.usernameField) as! String)
                    if username != nil {
                        self.delegate?.createMessageObject(with: username!)
                    }
                    else {
                        print("User not found")
                    }
                }
            }
        }
    }
    
    // send the message to the collection of messages
    func  sendMessage(_ username: String, _ email: String, _ time: String, _ message: String) {
        db.collection(K.FB.messageCollection).addDocument(data: [
            K.FB.usernameField: username,
            K.FB.emailField: email,
            K.FB.messageField: message,
            K.FB.orderField: Date().timeIntervalSince1970,
            K.FB.timeField: time
        ]) { (error) in
            if let error = error {
                print("Error saving data to firestore: \(error)")
            } else {
                self.delegate?.didPassed()
            }
        }
    }
    
}
