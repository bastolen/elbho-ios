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
    
    @IBOutlet weak var TabBar: UITabBar!
    @IBOutlet weak var DateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Afspraken"
        if(!KeychainWrapper.standard.hasValue(forKey: "authToken")) {
            // Not logged in, show login screen
            navigationController?.setViewControllers([mainStoryboard.instantiateViewController(identifier: "LoginViewController")], animated:true)
            return
        }
        
        setupMenu()
        setupDateLabel()
        setupTabBar()
    }
    
    private func setupTabBar() {
        let tabItem1 = UITabBarItem(title: "agenda_open".localize, image: UIImage(named: "OpenAgenda"), selectedImage: UIImage(named: "OpenAgendaSelected"))
        tabItem1.tag = 0
        tabItem1.badgeValue = "1"
        
        let tabItem2 = UITabBarItem(title: "agenda_accepted".localize, image: UIImage(named: "AcceptedAgenda"), selectedImage: UIImage(named: "AcceptedAgendaSelected"))
        tabItem2.tag = 1
        
        let tabItem3 = UITabBarItem(title: "agenda_done".localize, image: UIImage(named: "DoneAgenda"), selectedImage: UIImage(named: "DoneAgendaSelected"))
        tabItem3.tag = 2
        
        TabBar.items = [tabItem1, tabItem2, tabItem3]
        TabBar.selectedItem = tabItem1
        TabBar.delegate = self
    }
    
    private func setupDateLabel() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        DateLabel.text = formatter.string(from: date)
    }
    
    private func setupMenu()
    {
        let SideMenuView = mainStoryboard.instantiateViewController(identifier: "SideMenuView") as! SideMenuNavigationController
        SideMenuManager.default.leftMenuNavigationController = SideMenuView
        SideMenuView.statusBarEndAlpha = 0
    }
}

extension ViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item.tag)
    }
}
