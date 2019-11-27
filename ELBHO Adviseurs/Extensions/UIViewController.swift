//
//  UIViewController.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 26/11/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents.MDCSnackbarMessage

extension UIViewController {
    
    func showSnackbarPrimary(_ text: String) -> Void {
        let message = MDCSnackbarMessage(text: text)
        
        MDCSnackbarManager.messageTextColor = .white
        MDCSnackbarManager.snackbarMessageViewBackgroundColor = UIColor(named: "Primary")
        MDCSnackbarManager.show(message)
    }
    
    func showSnackbarSecondary(_ text: String) -> Void {
        let message = MDCSnackbarMessage(text: text)
        
        MDCSnackbarManager.messageTextColor = .white
        MDCSnackbarManager.snackbarMessageViewBackgroundColor = UIColor(named: "Secondary")
        MDCSnackbarManager.show(message)
    }
    
    func showSnackbarDanger(_ text: String) -> Void {
        let message = MDCSnackbarMessage(text: text)
        
        MDCSnackbarManager.messageTextColor = .white
        MDCSnackbarManager.snackbarMessageViewBackgroundColor = UIColor(named: "Danger")
        MDCSnackbarManager.show(message)
    }
    
    func showSnackbarSuccess(_ text: String) -> Void {
        let message = MDCSnackbarMessage(text: text)
        
        MDCSnackbarManager.messageTextColor = .white
        MDCSnackbarManager.snackbarMessageViewBackgroundColor = UIColor(named: "Success")
        MDCSnackbarManager.show(message)
    }
    
    func hideKeyboardWhenTappingOutside() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
