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
import CoreLocation
import MessageUI

class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    static var SelectedItemTag: Int = 0
    let refreshControl = UIRefreshControl()
    
    private var callSend: Bool = false
    
    private var openAppointments: [Appointment?] = []
    private var acceptedAppointments: [Appointment?] = []
    private var doneAppointments: [Appointment?] = []
    private var shownItems: [Appointment?] = []
    
    @IBOutlet weak var TabBar: UITabBar!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var TableView: UITableView!
    
    override func viewDidLoad() {
        checkLoggedIn()
        super.viewDidLoad()
        title = "title_appointment".localize
        TableView.dataSource = self
        TableView.delegate = self
        TableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        
        TableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .allEvents)
        initMenu(id: ViewController.SelectedItemTag)
        setupDateLabel()
        setupTabBar()
        initTableData()
        initPermissions()
    }
    
    private func initPermissions() {
        if( CLLocationManager.authorizationStatus() != .authorizedAlways){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.locManager.requestAlwaysAuthorization()
        }
    }
    
    private func checkLoggedIn() {
//        KeychainWrapper.standard.removeAllKeys()
//        KeychainWrapper.standard.set("testToken", forKey: "authToken")

        if(!KeychainWrapper.standard.hasValue(forKey: "authToken")) {
            // Not logged in, show login screen
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            navigationController?.setViewControllers([mainStoryboard.instantiateViewController(identifier: "LoginViewController")], animated:true)
            return
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if (
            !KeychainWrapper.standard.hasValue(forKey: "AdvisorId") ||
                !KeychainWrapper.standard.hasValue(forKey: "AdvisorName")
            ) {
            APIService.getLoggedInAdvisor().subscribe(onNext: {advisor in
                KeychainWrapper.standard.set(advisor._id, forKey: "AdvisorId")
                KeychainWrapper.standard.set("\(advisor.FirstName) \(advisor.LastName)", forKey: "AdvisorName")
            }, onError: {error in
                self.showSnackbarDanger("error_api".localize)
            }).disposed(by: disposeBag)
        }
    }
    
    private func initTableData() {
        callSend = true
        refreshControl.beginRefreshing()
        Observable<Any>.combineLatest(
            APIService.getAppointmentRequests(),
            APIService.getAppointments(parameters: ["after": Date()]),
            APIService.getAppointments(parameters: ["before": Date(), "sort": "DESC"])
        ).subscribe(onNext: { requests, acceptedAppointments, doneAppointments in
            self.openAppointments = requests
            self.acceptedAppointments = acceptedAppointments
            self.doneAppointments = doneAppointments
            self.fillTheTable()
            self.setupTabBar()
            self.callSend = false
            self.refreshControl.endRefreshing()
        }, onError: {error in
            self.showSnackbarDanger("error_api".localize)
            self.callSend = false
            self.refreshControl.endRefreshing()
        }).disposed(by: disposeBag)
    }
    
    private func fillTheTable() {
        switch ViewController.SelectedItemTag {
        case 0:
            shownItems = openAppointments
            break;
        case 1:
            shownItems = acceptedAppointments
            break;
        case 2:
            shownItems = doneAppointments
            break;
        default:
            shownItems = openAppointments
            break;
        }
        TableView.reloadData()
    }
    
    
    private func setupTabBar() {
        let tabItem1 = UITabBarItem(title: "agenda_open".localize, image: UIImage(named: "OpenAgenda"), selectedImage: UIImage(named: "OpenAgendaSelected"))
        tabItem1.tag = 0
        if (openAppointments.count != 0 ) {
            tabItem1.badgeValue = String(openAppointments.count)
        }
        
        let tabItem2 = UITabBarItem(title: "agenda_accepted".localize, image: UIImage(named: "AcceptedAgenda"), selectedImage: UIImage(named: "AcceptedAgendaSelected"))
        tabItem2.tag = 1
        var counter = 0
        acceptedAppointments.forEach{appointment in
            if(Calendar.current.isDateInToday(appointment!.StartTime)) {
                counter+=1
            }
        }
        if (counter != 0) {
            tabItem2.badgeValue = String(counter)
        }
        let tabItem3 = UITabBarItem(title: "agenda_done".localize, image: UIImage(named: "DoneAgenda"), selectedImage: UIImage(named: "DoneAgendaSelected"))
        tabItem3.tag = 2
        
        TabBar.items = [tabItem1, tabItem2, tabItem3]
        TabBar.selectedItem = TabBar.items![ViewController.SelectedItemTag]
        TabBar.delegate = self
    }
    
    private func setupDateLabel() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        DateLabel.text = formatter.string(from: date)
    }
    
    @objc func refresh() {
        if(!callSend) {
            initTableData()
        }
    }
    
    private func clearItems() {
        self.shownItems = []
        self.acceptedAppointments = []
        self.doneAppointments = []
        self.openAppointments = []
        self.TableView.reloadData()
    }
    
    private func prepareButtons(_ number: Int, _ item: Appointment) -> [DetailViewButton] {
        if(number == 0) {
            return getOpenButtons(item)
        }
        
        if (number == 1) {
            return getAcceptedButtons(item)
        }
        
        if(number == 2) {
            return [];
        }
        
        return [];
    }
    
    private func getOpenButtons(_ item: Appointment) -> [DetailViewButton] {
        return [
            DetailViewButton(text: "button_reject".localize, style: .danger, image: UIImage(systemName: "xmark"), clicked: {
                if(!self.callSend) {
                    APIService.respondToRequest(requestId: item._id, accept: false).subscribe(onNext: {
                        self.showSnackbarSuccess("appointment_rejected".localize)
                        self.clearItems()
                        self.initTableData()
                        self.navigationController?.popViewController(animated: true)
                    }, onError: {error in
                        self.showSnackbarDanger("error_api".localize)
                    }).disposed(by: self.disposeBag)
                }
            }),
            DetailViewButton(text: "button_accept".localize, style: .success, image: UIImage(systemName: "checkmark"), clicked: {
                if(!self.callSend) {
                    APIService.respondToRequest(requestId: item._id, accept: true).subscribe(onNext: {
                        self.showSnackbarSuccess("appointment_accepted".localize)
                        self.clearItems()
                        self.initTableData()
                        self.navigationController?.popViewController(animated: true)
                    }, onError: { error in
                        self.showSnackbarDanger("error_api".localize)
                    }).disposed(by: self.disposeBag)
                }
            })
        ]
    }
    
    private func getAcceptedButtons(_ item: Appointment) -> [DetailViewButton] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if (KeychainWrapper.standard.string(forKey: "trackingId") == item._id) {
            return [
                DetailViewButton(text: "button_arrive".localize, style: .primary, image: UIImage(systemName: "car.fill"), clicked: {
                    KeychainWrapper.standard.removeObject(forKey: "trackingId")

                    appDelegate.stopTracking()
                    self.showSnackbarSuccess("appointment_arrived".localize)
                    self.navigationController?.popViewController(animated: true)
                })
            ]
        } else if(Calendar.current.isDateInToday(item.StartTime) && !KeychainWrapper.standard.hasValue(forKey: "trackingId")) {
            return [
                DetailViewButton(text: "button_leave".localize, style: .primary, image: UIImage(systemName: "checkmark"), clicked: {
                    KeychainWrapper.standard.set(item._id, forKey: "trackingId")
                    appDelegate.startTracking()
                    self.showSnackbarSuccess("appointment_left".localize)
                    self.navigationController?.popViewController(animated: true)
                })
            ]
        } else {
            return []
        }
    }
}

extension ViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        ViewController.SelectedItemTag = item.tag
        MenuViewController.selectedItem = item.tag
        fillTheTable()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath ) as! CustomTableViewCell
        let item = shownItems[indexPath.row]!
        let formatter = DateFormatter()
        formatter.dateFormat = "EE"
        cell.DayLabel.text = formatter.string(from: item.StartTime).uppercased()
        formatter.dateFormat = "dd-MM"
        cell.DateLabel.text = formatter.string(from: item.EndTime)
        
        formatter.dateFormat = "HH:mm"
        cell.TimeLocationLabel.text = "\( formatter.string(from: item.StartTime) ) - \( formatter.string(from: item.EndTime) ), \( item.Address )"
        cell.CompanyLabel.text = item.COCName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
 
        let detailVc = mainStoryboard.instantiateViewController(withIdentifier:
            "AppointmentDetailViewController") as! AppointmentDetailViewController
        let item = shownItems[indexPath.row]!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = "\( formatter.string(from: item.StartTime) ) - \( formatter.string(from: item.EndTime) )"
        
        formatter.dateFormat = "EEEE d MMMM yyyy"
        var title: String
        switch ViewController.SelectedItemTag {
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
        detailVc.buttons = prepareButtons(ViewController.SelectedItemTag, item)
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
            DetailViewRow(title: "appointment_detail_contact_email".localize, content: item.ContactPersonEmail, icon: UIImage(named: "MailIcon"), iconClicked: {
                let url = URL(string: "mailto:\(item.ContactPersonEmail)")
                UIApplication.shared.open(url!)
            }),
            DetailViewRow(title: "appointment_detail_date".localize, content: formatter.string(from: item.StartTime), icon: nil, iconClicked: {}),
            DetailViewRow(title: "appointment_detail_time".localize, content: timeString, icon: nil, iconClicked: {}),
            DetailViewRow(title: "appointment_detail_comment".localize, content: item.Comment, icon: nil, iconClicked: {}),
        ]
        
        navigationController?.pushViewController(detailVc, animated: true)
    }
    
}
