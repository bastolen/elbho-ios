//
//  ViewController.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 11/11/2019.
//  Copyright © 2019 Bas Tolen. All rights reserved.
//

import UIKit
import RxSwift
import SwiftKeychainWrapper
import MaterialComponents
import SideMenu

class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if(!KeychainWrapper.standard.hasValue(forKey: "authToken")) {
            // Not logged in, show login screen
            navigationController?.setViewControllers([mainStoryboard.instantiateViewController(identifier: "LoginViewController")], animated:true)
            return
        }
        // Present a modal alert
        let alertController = MDCAlertController(title: "titleString", message: "messageString")
        let action = MDCAlertAction(title:"OK") { (action) in print("OK") }
        alertController.addAction(action)
        present(alertController, animated:true, completion: nil)
        
        // Menu
        let SideMenuView = mainStoryboard.instantiateViewController(identifier: "SideMenuView") as! SideMenuNavigationController
        SideMenuManager.default.leftMenuNavigationController = SideMenuView
        
        SideMenuView.statusBarEndAlpha = 0
        
    }
}
