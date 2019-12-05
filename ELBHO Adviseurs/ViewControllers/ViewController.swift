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
import MessageUI

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
        let appointment1 = Appointment(Id: "", AppointmentDatetime: Date(), Comment: "This is a comment that should be longer for one line, just to check if the item looks right with a longer comment", Address: "Ohmstraat 11 Haarlem", PhoneNumber: "0612345678", ContactPersonName: "Bas Tolen", ContactPersonPhoneNumber: "0612345678", ContactPersonFunction: "CEO", Active: true, Website: "https://www.bos-tol.nl", Logo: "", COCNumber: "6435453", COCName: "Bos-Tol", FirstChoice: "", SecondChoice: "", ThirdChoice: "", CreatedDate: Date(), ModifiedDate: Date())
        
        let appointment2 = Appointment(Id: "", AppointmentDatetime: Date(), Comment: "", Address: "Richard Holkade 14 Haarlem", PhoneNumber: "", ContactPersonName: "", ContactPersonPhoneNumber: "", ContactPersonFunction: "", Active: true, Website: "", Logo: "", COCNumber: "", COCName: "ELBHO", FirstChoice: "", SecondChoice: "", ThirdChoice: "", CreatedDate: Date(), ModifiedDate: Date())
        
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
        cell.TimeLocationLabel.text = "\( formatter.string(from: item.AppointmentDatetime) ) - \( formatter.string(from: item.AppointmentDatetime.addingTimeInterval(2*60*60)) ), \( item.Address )"
        cell.CompanyLabel.text = item.COCName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVc = mainStoryboard.instantiateViewController(withIdentifier:
            "AppointmentDetailViewController") as! AppointmentDetailViewController
        let item = shownItems[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = "\( formatter.string(from: item.AppointmentDatetime) ) - \( formatter.string(from: item.AppointmentDatetime.addingTimeInterval(2*60*60)) )"
        
        formatter.dateFormat = "EEEE d MMMM"
        var title: String
        switch SelectedItemTag {
        case 0:
            title = "appointment_detail_title_open"
            break
        case 1:
            title = "appointment_detail_title_accepted"
            break
        case 2:
            title = "appointment_detail_title_done"
            break
        default:
            title = item.COCName
            break
        }
        
        detailVc.title = title.localize
        
        detailVc.rows = [
            DetailViewRow(title: "appointment_detail_name".localize, content: item.COCName, icon: nil, iconClicked: {}),
            DetailViewRow(title: "appointment_detail_address".localize, content: item.Address, icon: UIImage(named: "RouteIcon"), iconClicked: {
                let url = URL(string: "http://maps.apple.com/?address=\(item.Address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)")
                UIApplication.shared.open(url!)
            }),
            DetailViewRow(title: "appointment_detail_contact_name".localize, content: item.ContactPersonName, icon: nil, iconClicked: {}),
            DetailViewRow(title: "appointment_detail_contact_function".localize, content: item.ContactPersonFunction, icon: nil, iconClicked: {}),
            DetailViewRow(title: "appointment_detail_contact_phone".localize, content: item.ContactPersonPhoneNumber, icon: UIImage(named: "CallIcon"), iconClicked: {
                let url = URL(string: "tel://\(item.ContactPersonPhoneNumber)")
                UIApplication.shared.open(url!)
            }),
            DetailViewRow(title: "appointment_detail_contact_email".localize, content: item.Website, icon: UIImage(named: "MailIcon"), iconClicked: {
                let url = URL(string: item.Website)
                UIApplication.shared.open(url!)
            }),
            DetailViewRow(title: "appointment_detail_date".localize, content: formatter.string(from: item.AppointmentDatetime), icon: nil, iconClicked: {}),
            DetailViewRow(title: "appointment_detail_time".localize, content: timeString, icon: nil, iconClicked: {}),
            DetailViewRow(title: "appointment_detail_comment".localize, content: item.Comment, icon: nil, iconClicked: {}),
        ]
        
        detailVc.buttons = []
        
        navigationController?.pushViewController(detailVc, animated: true)
    }

}
