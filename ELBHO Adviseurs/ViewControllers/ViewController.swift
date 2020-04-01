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
import RxSwift

class ViewController: UIViewController {
    @IBOutlet weak var TryAgainButton: MDCButton!
    @IBOutlet weak var LogOutButton: MDCButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        navigationController?.isNavigationBarHidden = true

        TryAgainButton.setPrimary()
        TryAgainButton.setTitle("button_try_again".localize, for: .normal)
        LogOutButton.setTextPrimary()
        LogOutButton.setBackgroundColor(UIColor(named: "BackgroundColor"), for: .normal)
        LogOutButton.setTitle("button_logout".localize, for: .normal)
        
        super.viewDidLoad()
        if checkLoggedIn() {
            initAdvisor()
            checkAuth()
        }
    }
    
    @IBAction func LogOutClicked(_ sender: Any) {
        self.logOut()
    }
    
    @IBAction func TryAgainClicked(_ sender: Any) {
        self.checkAuth()
    }
    
    private func checkAuth() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if (KeychainWrapper.standard.hasValue(forKey: "CloseAppDate")) {
            let stopDate = formatter.date(from: KeychainWrapper.standard.string(forKey: "CloseAppDate")!)!.timeIntervalSinceNow

            // It has more than 5 min, require auth
            if (stopDate < -1 * 5 * 60) {
                self.faceId()
            } else {
                let mainStoryboard = UIStoryboard(name: "Appointment", bundle: nil)
                self.navigationController?.setViewControllers([mainStoryboard.instantiateViewController(identifier: "AppointmentViewController")], animated:true)
            }
        } else {
            self.faceId()
        }
    }
    
    private func faceId() {
        let context = LAContext()
        context.localizedCancelTitle = "faceid_cancel".localize
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "faceid_reason".localize
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                if success {
                    DispatchQueue.main.async { [unowned self] in
                        let mainStoryboard = UIStoryboard(name: "Appointment", bundle: nil)
                        self.navigationController?.setViewControllers([mainStoryboard.instantiateViewController(identifier: "AppointmentViewController")], animated:true)
                    }
                }
            }
        }
    }
    
    private func logOut() {
        KeychainWrapper.standard.removeAllKeys()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        navigationController?.setViewControllers([mainStoryboard.instantiateViewController(identifier: "LoginViewController")], animated:true)
    }
    
    private func checkLoggedIn() -> Bool {
//        KeychainWrapper.standard.removeAllKeys()
//        KeychainWrapper.standard.set("testToken", forKey: "authToken")

        if(!KeychainWrapper.standard.hasValue(forKey: "authToken")) {
            // Not logged in, show login screen
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            navigationController?.setViewControllers([mainStoryboard.instantiateViewController(identifier: "LoginViewController")], animated:true)
            return false
        }
        return true
    }
    
    private func initAdvisor() {
        if (
            !KeychainWrapper.standard.hasValue(forKey: "AdvisorId") ||
                !KeychainWrapper.standard.hasValue(forKey: "AdvisorName")
            ) {
            APIService.getLoggedInAdvisor().subscribe(onNext: {advisor in
                KeychainWrapper.standard.set(advisor._id, forKey: "AdvisorId")
                KeychainWrapper.standard.set("\(advisor.FirstName) \(advisor.LastName)", forKey: "AdvisorName")
            }, onError: {error in
                self.showSnackbarDanger("error_api".localize)
            }).disposed(by: disposeBag)
        }
    }
}
