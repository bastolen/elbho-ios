//
//  MenuViewController.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 06/02/2020.
//  Copyright © 2020 Otters. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    static public var selectedItem: Int = 0;

    @IBOutlet weak var TableView: UITableView!
    let menuItems: [MenuItem] = [
        MenuItem(text: "Open", viewControllerIdentifier: "MainViewController", storyboardIdentifier: "Main", id: 0),
        MenuItem(text: "Aanstaand", viewControllerIdentifier: "MainViewController", storyboardIdentifier: "Main", id: 1),
        MenuItem(text: "Afgerond", viewControllerIdentifier: "MainViewController", storyboardIdentifier: "Main", id: 2),
        MenuItem(text: "Beschikbaarheid", viewControllerIdentifier: "BeschikbaarheidViewController", storyboardIdentifier: "Beschikbaarheid", id: 3),
        MenuItem(text: "Auto", viewControllerIdentifier: "CarsViewController", storyboardIdentifier: "Car", id: 4),
        MenuItem(text: "Facturen", viewControllerIdentifier: "InvoiceViewController", storyboardIdentifier: "Invoice", id: 5)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.dataSource = self
        TableView.delegate = self
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
       }
        let menuItem: MenuItem = self.menuItems[indexPath.row]
        
        cell!.textLabel?.text = menuItem.text
        var color: UIColor
        if (MenuViewController.selectedItem == menuItem.id){
            color = .blue
        } else {
            color = .red
        }
        
        cell!.textLabel?.backgroundColor = color
       return cell!
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if MenuViewController.selectedItem < 3 && self.menuItems[indexPath.row].id < 3 {
            ViewController.SelectedItemTag = MenuViewController.selectedItem
        }
        MenuViewController.selectedItem = self.menuItems[indexPath.row].id
        let storyboard = UIStoryboard(name: self.menuItems[indexPath.row].storyboardIdentifier, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier:
            self.menuItems[indexPath.row].viewControllerIdentifier)
        navigationController?.setViewControllers([controller], animated: true)
        
    }
}
