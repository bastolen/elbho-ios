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
    let selectedBarImages: [UIImage?] = [
        UIImage(named: "OpenAgendaSelected"),
        UIImage(named: "AcceptedAgendaSelected"),
        UIImage(named: "DoneAgendaSelected"),
    ]
    let barImages: [UIImage?] = [
        UIImage(named: "OpenAgenda"),
        UIImage(named: "AcceptedAgenda"),
        UIImage(named: "DoneAgenda")
    ]
    
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
        let itemOpen = UITabBarItem(title: "agenda_open".localize, image: selectedBarImages[0], tag: 0)
        itemOpen.badgeValue = "5"
        
        let itemAccepted = UITabBarItem(title: "agenda_accepted".localize, image: barImages[1], tag: 1)
        
        let itemDone = UITabBarItem(title: "agenda_done".localize, image: barImages[2], tag: 2)
        // Create the bar
        let tabBar = MDCTabBar(frame: view.bounds)
        tabBar.items = [
            itemOpen,
            itemAccepted,
            itemDone,
        ]
        tabBar.itemAppearance = .titledImages
        tabBar.setTitleColor(UIColor(named: "DisabledText"), for: .normal)
        tabBar.setTitleColor(UIColor(named: "Primary"), for: .selected)
        tabBar.delegate = self
        tabBar.sizeToFit()
        
        // Add the bar
        Container.addSubview(tabBar)
    }
}

extension ViewController: MDCTabBarDelegate {
    func tabBar(_ tabBar: MDCTabBar, didSelect item: UITabBarItem) {
        for (index, element) in tabBar.items.enumerated() {
            if element == item {
                element.image = selectedBarImages[index]
            } else {
                element.image = barImages[index]
            }
        }
// https://www.raywenderlich.com/316-google-material-design-tutorial-for-ios-getting-started
// Check this
        switch item.tag {
        case 0:
            print("agenda_open".localize)
            break
        case 1:
            print("agenda_accepted".localize)
            break
        case 2:
            print("agenda_done".localize)
            break
        default:
            print("something else")
            break
        }
    }
}
