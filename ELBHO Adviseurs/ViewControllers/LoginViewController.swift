//
//  LoginViewController.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 25/11/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import UIKit
import MaterialComponents
import RxSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: MDCTextField!
    
    @IBOutlet weak var passwordTextField: MDCTextField!
    
    @IBOutlet weak var loginButton: MDCButton!
    
    private var callSend: Bool = false;
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappingOutside()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        navigationController?.isNavigationBarHidden = true
        
        emailTextField.delegate = self
        emailTextField.clearButtonMode = .never
        passwordTextField.delegate = self
        passwordTextField.clearButtonMode = .never
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 150
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        if emailTextField.hasText && passwordTextField.hasText && !callSend {
            callSend = true
            APIService.login(email: emailTextField.text!, password: passwordTextField.text!)
                .subscribe(onNext: {result in
                    if (result) {
                        // User is logged in
                    } else {
                        // Call failed
                    }
                    self.callSend = false
                }, onError: {Error in
                    if(Error as! CustomError == .passwordMatch) {
                        // Password incorrect
                    } else {
                        // other error
                    }
                    self.callSend = false
                }).disposed(by: disposeBag)
        } else if !callSend {
            // Fields are not all filled
            // show this message: error_empty_field
        } else {
            // Call is send, probably do nothing
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
                nextField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
                return true;
            }
        } else if textField.returnKeyType == .go {
            textField.endEditing(true)
        }
        return false
    }
}
