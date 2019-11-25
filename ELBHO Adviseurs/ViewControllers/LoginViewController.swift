//
//  LoginViewController.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 25/11/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import UIKit
import MaterialComponents

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: MDCTextField!
    
    @IBOutlet weak var passwordTextField: MDCTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        navigationController?.isNavigationBarHidden = true

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension LoginViewController: UITextFieldDelegate {
    private func textFieldShouldReturn(_ textField: MDCTextField) -> Bool {
        print(true)
        if textField.returnKeyType == .next {
            if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
                nextField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
                return true;
            }
        } else if textField.returnKeyType == .go {
            textField.endEditing(false)
        }
        return false
    }
}
