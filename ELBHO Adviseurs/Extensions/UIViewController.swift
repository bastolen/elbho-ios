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
    // MARK: Menu
    /**
     Menu functions. Used for interacting with the menu
     */
    
    /**
     Create the menu button and initializes the actions to open the menu
     */
    func initMenu(id: Int) {
        MenuViewController.selectedItem = id
        let button = UIBarButtonItem(image: UIImage(named: "MenuIcon"), style: .plain, target: self, action: #selector(menuTapped))
        button.tintColor = .white
        navigationItem.leftBarButtonItem = button

        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapRecognizer)
        
        view.addGestureRecognizer(edgePan)
        
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "Primary")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    @objc func viewTapped(_ recognizer: UITapGestureRecognizer) {
        recognizer.cancelsTouchesInView = false
        if (view.viewWithTag(999) != nil) {
            let hit = (view.viewWithTag(999)?.frame.contains(recognizer.location(in: self.view)))!
            if !hit {
                recognizer.cancelsTouchesInView = true
                return self.menuTapped()
            }
        }
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            self.menuTapped()
        }
    }
    
    /**
     Open or close the menu
     */
    @objc func menuTapped() {
        let menuWidth = self.view.frame.width*0.75
        let animationTime = 0.2
        if (view.viewWithTag(999) == nil) {
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.frame = CGRect(x: 0, y: 0, width: menuWidth, height: self.view.frame.height)
            containerView.tag = 999
            view.addSubview(containerView)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let menuViewController = storyboard.instantiateViewController(withIdentifier:
                "MenuViewController") as! MenuViewController
            
            menuViewController.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: self.view.frame.height)
            addChild(menuViewController)
            UIView.animate(withDuration: animationTime, delay: 0.0, options: [.curveLinear], animations: {
                menuViewController.view.frame = CGRect(x: 0, y: 0, width: menuWidth, height: self.view.frame.height)
            })
            
            menuViewController.view.translatesAutoresizingMaskIntoConstraints = true
            containerView.addSubview(menuViewController.view)
        } else {
            UIView.animate(withDuration: animationTime, delay: 0.0, options: [.curveLinear], animations: {
                self.view.viewWithTag(999)?.subviews.first!.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: self.view.frame.height)
            }, completion: { _ in
                self.view.viewWithTag(999)?.removeFromSuperview()
            })
            
        }
    }
    
    // MARK: Snackbars
    /**
     Shows a small message to the user in different styles
     */
    func showSnackbarPrimary(_ text: String) -> Void {
        let message = MDCSnackbarMessage(text: text)
        
        MDCSnackbarManager.messageTextColor = .white
        MDCSnackbarManager.snackbarMessageViewBackgroundColor = UIColor(named: "Primary")
        MDCSnackbarManager.show(message)
    }
    
    func showSnackbarSecondary(_ text: String) -> Void {
        let message = MDCSnackbarMessage(text: text)
        MDCSnackbarManager.setPresentationHostView(self.navigationController?.view)
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
    
    // MARK: Keyboard functions
    /**
     Used for showing and hiding the keyboard for different interactions
     */
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.navigationController?.view.frame.origin.y == 0 {
                self.navigationController?.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.navigationController?.view.frame.origin.y != 0 {
            self.navigationController?.view.frame.origin.y = 0
        }
    }
    
    func hideKeyboardWhenTappingOutside() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard(_ recognizer: UITapGestureRecognizer) {
        recognizer.cancelsTouchesInView = true
        view.endEditing(true)
    }
}
