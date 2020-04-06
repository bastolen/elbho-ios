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
    
    @IBOutlet weak var BrandIconTop: NSLayoutConstraint!
    private var defaultConstraint: CGFloat = 1
    var emailController: MDCTextInputControllerUnderline?
    @IBOutlet weak var emailTextField: MDCTextField!
    
    var passwordController: MDCTextInputControllerUnderline?
    @IBOutlet weak var passwordTextField: MDCTextField!
    
    @IBOutlet weak var loginButton: MDCButton!
    
    private var callSend: Bool = false;
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultConstraint = BrandIconTop.constant
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        

        navigationController?.isNavigationBarHidden = true
        
        loginButton.setPrimary()
        loginButton.setTitle("button_login".localize, for: .normal)

        emailController = MDCTextInputControllerUnderline(textInput: emailTextField)
        emailController?.activeColor = UIColor(named: "Primary")
        emailTextField.delegate = self
        emailTextField.placeholderLabel.text = "input_email".localize
        emailTextField.placeholderLabel.textColor = UIColor(named: "Primary")!
        emailTextField.clearButtonMode = .never
        
        passwordController = MDCTextInputControllerUnderline(textInput: passwordTextField)
        passwordController?.activeColor = UIColor(named: "Primary")
        passwordTextField.placeholderLabel.text = "input_password".localize
        passwordTextField.placeholderLabel.textColor = UIColor(named: "Primary")!
        passwordTextField.delegate = self
        passwordTextField.clearButtonMode = .never
    }
    
    /**
     Move the screen up when showing the keyboard
     */
    @objc override func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if (BrandIconTop.constant < keyboardSize.height) {
                BrandIconTop.constant = defaultConstraint - keyboardSize.height
            }
        }
    }

    /**
     Move the screen down when hiding the keyboard
     */
    @objc override func keyboardWillHide(notification: NSNotification) {
        if (BrandIconTop.constant != defaultConstraint) {
            BrandIconTop.constant = defaultConstraint
        }
    }
    
    /**
     Check fields and login
     */
    @IBAction func loginClicked() {
        if emailTextField.hasText && passwordTextField.hasText && !callSend {
            callSend = true
            loginButton.isEnabled = false
            APIService.login(email: emailTextField.text!, password: passwordTextField.text!)
                .subscribe(onNext: {result in
                    if (result) {
                        // User is logged in
                        let mainStoryboard = UIStoryboard(name: "Appointment", bundle: nil)
                        self.navigationController?.setViewControllers([mainStoryboard.instantiateViewController(identifier: "AppointmentViewController")], animated:true)
                    } else {
                        // Saving the token failed
                        self.showSnackbarDanger("error_general".localize)
                    }
                    self.callSend = false
                    self.loginButton.isEnabled = true
                }, onError: {Error in
                    if(Error as! CustomError == .unauthorized) {
                        // Password is wrong
                        self.showSnackbarDanger("error_password_match".localize)
                    } else {
                        // The api failed
                        self.showSnackbarDanger("error_api".localize)
                    }
                    self.callSend = false
                    self.loginButton.isEnabled = true
                }).disposed(by: disposeBag)
        } else if !callSend {
            // One of the fields is empty
            showSnackbarSecondary("error_empty_field".localize)
        } else {
            // Call is send, probably do nothing
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    /**
     Settup the enter button for the keyboards
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
                nextField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
                return true;
            }
        } else if textField.returnKeyType == .go {
            loginClicked()
            textField.endEditing(true)
        }
        return false
    }
}
