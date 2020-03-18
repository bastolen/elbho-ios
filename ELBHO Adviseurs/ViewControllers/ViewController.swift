//
//  ViewController.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 11/11/2019.
//  Copyright © 2019 Bas Tolen. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import MaterialComponents
import CoreLocation
import LocalAuthentication

class ViewController: UIViewController {
    @IBOutlet weak var TryAgainButton: MDCButton!
    @IBOutlet weak var LogOutButton: MDCButton!
    
    override func viewDidLoad() {
        navigationController?.isNavigationBarHidden = true
        checkLoggedIn()
        super.viewDidLoad()
        TryAgainButton.setPrimary()
        TryAgainButton.setTitle("button_try_again".localize, for: .normal)
        LogOutButton.setTextPrimary()
        LogOutButton.setBackgroundColor(UIColor(named: "BackgroundColor"), for: .normal)
        LogOutButton.setTitle("button_logout".localize, for: .normal)
        checkAuth()
    }
    
    @IBAction func LogOutClicked(_ sender: Any) {
        self.logOut()
    }
    
    @IBAction func TryAgainClicked(_ sender: Any) {
        self.checkAuth()
    }
    
    private func checkAuth() {
        let context = LAContext()
        context.localizedCancelTitle = "faceid_cancel".localize
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "faceid_reason".localize
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                if success {
                    DispatchQueue.main.async { [unowned self] in
                        let mainStoryboard = UIStoryboard(name: "Appointment", bundle: nil)
                        self.navigationController?.setViewControllers([mainStoryboard.instantiateViewController(identifier: "AppointmentViewController")], animated:true)                    }
                }
            }
        }
    }
    
    private func logOut() {
        KeychainWrapper.standard.removeAllKeys()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        navigationController?.setViewControllers([mainStoryboard.instantiateViewController(identifier: "LoginViewController")], animated:true)
    }
    
    private func checkLoggedIn() {
//        KeychainWrapper.standard.removeAllKeys()
//        KeychainWrapper.standard.set("testToken", forKey: "authToken")

        if(!KeychainWrapper.standard.hasValue(forKey: "authToken")) {
            // Not logged in, show login screen
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            navigationController?.setViewControllers([mainStoryboard.instantiateViewController(identifier: "LoginViewController")], animated:true)
            return
        }
    }
}
