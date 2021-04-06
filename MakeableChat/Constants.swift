//
//  Constants.swift
//  MakeableChat
//
//  Created by Mariana Steblii on 06/04/2021.
//

import Foundation

struct K {
    static let loginToChatSegue = "loginToChat"
    static let registerToChatSegue = "registerToChat"
    static let cellNibName = "MessageCell"
    static let cellIdentifier = "reusableCell"
    
    struct Color {
        static let brightBlue = "brightBlue"
        static let lightBlue = "lightBlue"
        static let grey = "grey"
        static let black = "black"
        static let lightGrey = "lightGrey"
    }
    
    struct FB {
        static let userCollection = "users"
        static let messageCollection = "messages"
        static let orderField = "orderTime"
        static let usernameField = "username"
        static let emailField = "email"
        static let messageField = "message"
        static let timeField = "time"
    }
}
