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
    
    @IBOutlet weak var Container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Afspraken"
        
        if(!KeychainWrapper.standard.hasValue(forKey: "authToken")) {
            // Not logged in, show login screen
            navigationController?.setViewControllers([mainStoryboard.instantiateViewController(identifier: "LoginViewController")], animated:true)
            return
        }
        
        setupMenu()
        setupTabBar()
    }
    
    private func setupMenu()
    {
        let SideMenuView = mainStoryboard.instantiateViewController(identifier: "SideMenuView") as! SideMenuNavigationController
        SideMenuManager.default.leftMenuNavigationController = SideMenuView
        SideMenuView.statusBarEndAlpha = 0
    }
    
    private func setupTabBar() {
        // Create the items
        let itemOpen = UITabBarItem(title: "agenda_open".localize, image: UIImage(named: "AcceptedAgenda"), selectedImage: UIImage(named: "AcceptedAgendaSelected"))
        itemOpen.badgeValue = "5"
        let itemAccepted = UITabBarItem(title: "agenda_accepted".localize, image: UIImage(named: "OpenAgenda"), selectedImage: UIImage(named: "OpenAgendaSelected"))
        let itemDone = UITabBarItem(title: "agenda_done".localize, image: UIImage(named: "DoneAgenda"), selectedImage: UIImage(named: "DoneAgendaSelected"))
        
        // Create the bar
        let tabBar = MDCTabBar(frame: view.bounds)
        tabBar.items = [
            itemOpen,
            itemAccepted,
            itemDone,
        ]
        tabBar.itemAppearance = .titledImages
        tabBar.setTitleColor(UIColor(named: "Disabled"), for: .normal)
        tabBar.setTitleColor(UIColor(named: "Primary"), for: .selected)
        tabBar.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        tabBar.sizeToFit()
        
        // Add the bar
        Container.addSubview(tabBar)
    }
}
