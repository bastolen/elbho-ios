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
        
        loginButton.backgroundColor = UIColor(named: "Primary")
        loginButton.setTitle("login_button".localize, for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
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
            loginButton.isEnabled = false
            APIService.login(email: emailTextField.text!, password: passwordTextField.text!)
                .subscribe(onNext: {result in
                    if (result) {
                        // User is logged in
                        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        self.navigationController?.setViewControllers([mainStoryboard.instantiateViewController(identifier: "MainViewController")], animated:true)
                    } else {
                        // Saving the token failed
                        self.showSnackbar("error_general".localize)
                    }
                    self.callSend = false
                    self.loginButton.isEnabled = true
                }, onError: {Error in
                    if(Error as! CustomError == .passwordMatch) {
                        // Password is wrong
                        self.showSnackbar("error_password_match".localize)
                    } else {
                        // The api failed
                        self.showSnackbar("error_api".localize)
                    }
                    self.callSend = false
                    self.loginButton.isEnabled = true
                }).disposed(by: disposeBag)
        } else if !callSend {
            // One of the fields is empty
            showSnackbar("error_empty_field".localize)
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
