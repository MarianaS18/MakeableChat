//
//  UIController.swift
//  MakeableChat
//
//  Created by Mariana Steblii on 07/04/2021.
//

import UIKit

struct UIController {
    
    // color of textField en dark mode
    static func textFileldUpdate(textField: UITextField, placeholder: String) {
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor(named: K.Color.lightGrey)?.cgColor
        textField.layer.borderWidth = 0.5
        textField.tintColor = UIColor(named: K.Color.grey)
        textField.backgroundColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: K.Color.lightGrey)!])
    }

    // set the logo in the navigation bar on the center
    static func setLogo() -> UIView {
        let imageView = UIImageView(image: UIImage(named: K.navLogo))
        imageView.frame = CGRect(x: 0, y: 0, width: 170, height: 45)
        imageView.contentMode = .scaleAspectFit
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 170, height: 45))
        titleView.addSubview(imageView)
        titleView.backgroundColor = .clear
        return titleView
    }
    
}
