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
    var SelectedItemTag: Int = 0
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let refreshControl = UIRefreshControl()
    
    private var openAppointments: [Appointment] = []
    private var acceptedAppointments: [Appointment] = []
    private var doneAppointments: [Appointment] = []
    private var shownItems: [Appointment] = []
    
    @IBOutlet weak var TabBar: UITabBar!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var TableView: UITableView!
    
    override func viewDidLoad() {
        checkLoggedIn()
        super.viewDidLoad()
        title = "Afspraken"
        TableView.dataSource = self
        TableView.delegate = self
        TableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        
        TableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .allEvents)
        
        setupMenu()
        setupDateLabel()
        setupTabBar()
        fillTheTable()
    }
    
    private func checkLoggedIn() {
//        KeychainWrapper.standard.removeAllKeys()
        if(!KeychainWrapper.standard.hasValue(forKey: "authToken")) {
            // Not logged in, show login screen
            navigationController?.setViewControllers([mainStoryboard.instantiateViewController(identifier: "LoginViewController")], animated:true)
            return
        }
        
        if (!KeychainWrapper.standard.hasValue(forKey: "AdvisorId")) {
            APIService.getLoggedInAdvisor().subscribe(onNext: {advisor in
                KeychainWrapper.standard.set(advisor.Id, forKey: "AdvisorId")
            }, onError: {error in
                self.showSnackbarDanger("error_api".localize)
            }).disposed(by: disposeBag)
        }
    }
    
    private func fillTheTable() {
        let appointment1 = Appointment(Id: "", AppointmentDatetime: Date(), Comment: "", Address: "", PhoneNumber: "", ContactPersonName: "", ContactPersonPhoneNumber: "", ContactPersonFunction: "", Active: true, Website: "", Logo: "", COCNumber: "", COCName: "Bos-Tol", FirstChoice: "", SecondChoice: "", ThirdChoice: "", CreatedDate: Date(), ModifiedDate: Date())
        
        let appointment2 = Appointment(Id: "", AppointmentDatetime: Date(), Comment: "", Address: "", PhoneNumber: "", ContactPersonName: "", ContactPersonPhoneNumber: "", ContactPersonFunction: "", Active: true, Website: "", Logo: "", COCNumber: "", COCName: "ELBHO", FirstChoice: "", SecondChoice: "", ThirdChoice: "", CreatedDate: Date(), ModifiedDate: Date())
        
        shownItems = [appointment1, appointment2]
        TableView.reloadData()
        
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
        TabBar.selectedItem = TabBar.items![SelectedItemTag]
        TabBar.delegate = self
    }
    
    private func setupDateLabel() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        DateLabel.text = formatter.string(from: date)
    }
    
    private func setupMenu() {
        let SideMenuView = mainStoryboard.instantiateViewController(identifier: "SideMenuView") as! SideMenuNavigationController
        SideMenuManager.default.leftMenuNavigationController = SideMenuView
        SideMenuView.statusBarEndAlpha = 0
    }
    
    @objc func refresh() {
        TableView.reloadData()
        self.refreshControl.endRefreshing()
    }
}

extension ViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        SelectedItemTag = item.tag
        fillTheTable()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath ) as! CustomTableViewCell
        let item = shownItems[indexPath.row]
        let formatter = DateFormatter()
        formatter.dateFormat = "EE"
        cell.DayLabel.text = formatter.string(from: item.AppointmentDatetime)
        
        formatter.dateFormat = "dd-MM"
        cell.DateLabel.text = formatter.string(from: item.AppointmentDatetime)
        
        formatter.dateFormat = "HH:mm"
        cell.TimeLocationLabel.text = formatter.string(from: item.AppointmentDatetime)
        
        cell.CompanyLabel.text = item.COCName
        return cell
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return UITableView.automaticDimension;
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

}
