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
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Afspraken"
        
        if(KeychainWrapper.standard.hasValue(forKey: "authToken")) {
            // Not logged in, show login screen
            navigationController?.setViewControllers([mainStoryboard.instantiateViewController(identifier: "LoginViewController")], animated:true)
            return
        }
        
        // Menu
        let SideMenuView = mainStoryboard.instantiateViewController(identifier: "SideMenuView") as! SideMenuNavigationController
        SideMenuManager.default.leftMenuNavigationController = SideMenuView
        SideMenuView.statusBarEndAlpha = 0
        
    }
}
