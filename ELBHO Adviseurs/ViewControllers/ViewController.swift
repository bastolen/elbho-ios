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

class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(!KeychainWrapper.standard.hasValue(forKey: "authToken")) {
            // Not logged in, show login screen
            print("Not logged in")
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            navigationController?.setViewControllers([mainStoryboard.instantiateViewController(identifier: "LoginViewController")], animated:true)
        }
    }
}
