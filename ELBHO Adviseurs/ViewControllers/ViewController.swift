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
        APIService.login(email: "582297@student.inholland.nl", password: "lol").subscribe(onNext: {result in
            print("Login was succesfull: \(result)")
        }, onError: {Error in
            print(Error)
        }).disposed(by: disposeBag)
        
        APIService.getLoggedInAdvisor(true).subscribe(onNext: {result in
            print("Logged in account: \(result)")
        }, onError: {Error in
            print(Error)
        }).disposed(by: disposeBag)
    }
    
    
}

