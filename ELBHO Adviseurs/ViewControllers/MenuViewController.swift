//
//  MenuViewController.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 06/02/2020.
//  Copyright © 2020 Otters. All rights reserved.
//

import UIKit
import MaterialComponents
import SwiftKeychainWrapper

class MenuViewController: UIViewController {
    static public var selectedItem: Int = 0;

    @IBOutlet weak var BottomView: UIStackView!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var LogoutButton: MDCButton!
    
    let menuItems: [MenuItem] = [
        MenuItem(text: "menu_open".localize, viewControllerIdentifier: "AppointmentViewController", storyboardIdentifier: "Main", id: 0),
        MenuItem(text: "menu_accepted".localize, viewControllerIdentifier: "AppointmentViewController", storyboardIdentifier: "Main", id: 1),
        MenuItem(text: "menu_done".localize, viewControllerIdentifier: "AppointmentViewController", storyboardIdentifier: "Main", id: 2),
        MenuItem(text: "menu_availability".localize, viewControllerIdentifier: "BeschikbaarheidViewController", storyboardIdentifier: "Beschikbaarheid", id: 3),
        MenuItem(text: "menu_vehicle".localize, viewControllerIdentifier: "CarsViewController", storyboardIdentifier: "Car", id: 4),
        MenuItem(text: "menu_invoice".localize, viewControllerIdentifier: "InvoiceViewController", storyboardIdentifier: "Invoice", id: 5)
    ]
    
    override func viewDidLoad() {
        TableView.tableFooterView = UIView()
        TableView.dataSource = self
        TableView.delegate = self
        
        let third = self.view.frame.height / 3
        BottomView.frame = CGRect(x: 0, y: 0, width: BottomView.frame.width, height: third)
        
        LogoutButton.setTextPrimary()
        LogoutButton.setBackgroundColor(UIColor(named: "BackgroundColor"), for: .normal)
        LogoutButton.setTitle("button_logout".localize, for: .normal)
        
        let name = KeychainWrapper.standard.string(forKey: "AdvisorName")
        NameLabel.text = "menu_name_label".localizeWithVars(name ?? "Your Name Here")
        
        super.viewDidLoad()
    }
    
    @IBAction func LogoutButtonClicked(_ sender: Any) {
        KeychainWrapper.standard.removeAllKeys()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        navigationController?.setViewControllers([mainStoryboard.instantiateViewController(identifier: "LoginViewController")], animated:true)
    }
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
       if( !(cell != nil))
       {
        cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        cell!.backgroundColor = UIColor(named: "BackgroundColor")
       }
        let menuItem: MenuItem = self.menuItems[indexPath.row]
        
        cell!.textLabel?.text = menuItem.text
        
        if (MenuViewController.selectedItem == menuItem.id){
            cell!.textLabel?.textColor = UIColor(named: "Primary")

            cell!.textLabel?.font = UIFont.boldSystemFont(ofSize: (cell!.textLabel?.font.pointSize)!)
        }
        
       return cell!
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = self.menuItems[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: false)
        if selectedItem.id == MenuViewController.selectedItem {
            return
        }
        if selectedItem.id < 3 {
            AppointmentViewController.SelectedItemTag = selectedItem.id
        }
        MenuViewController.selectedItem = selectedItem.id
        let storyboard = UIStoryboard(name: selectedItem.storyboardIdentifier, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier:
            selectedItem.viewControllerIdentifier)
        navigationController?.setViewControllers([controller], animated: true)
        
    }
}
