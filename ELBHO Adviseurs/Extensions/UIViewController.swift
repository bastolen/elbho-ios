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
    
    func showAlert(title: String, message: String, actions: [MDCAlertAction]) -> Void {
        let alertController = MDCAlertController(title: title, message: message)
        actions.forEach{ action in
            alertController.addAction(action)
        }
        
        present(alertController, animated:true, completion: nil)
    }
    
    func moveViewUp() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
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
