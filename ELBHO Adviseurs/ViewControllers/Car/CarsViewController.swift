//
//  CarsViewController.swift
//  ELBHO Adviseurs
//
//  Created by Kevin Bosma on 08/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import UIKit
import RxSwift
import SwiftKeychainWrapper
import MaterialComponents

class CarsViewController : UIViewController {
    
    let nc = NotificationCenter.default
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bookCarButton: MDCButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let dateFormatter = DateFormatter()
    let carStoryboard = UIStoryboard(name: "Car", bundle: nil)
    
    private let disposeBag = DisposeBag()
    var items: [CarReservation?] = []
    private var callSend: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "title_car".localize
        topLabel.text = "car_header".localize
        bookCarButton.setTitle("button_car_reservation".localize.uppercased(), for: .normal)
        navigationController?.navigationBar.tintColor = .white
        
        nc.addObserver(self, selector: #selector(initContent), name: Notification.Name("reloadCarReservations"), object: nil)
        
        bookCarButton.setPrimary()
        mainView.layer.borderWidth = 1
        mainView.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(initContent), for: .allEvents)
        
        initMenu(id: 4)
        initContent()
    }
    
    @objc private func initContent() {
        refreshControl.beginRefreshing()
        var ophalenVanaf = Date()
        ophalenVanaf = Calendar.current.date(byAdding: .day, value: -1, to: ophalenVanaf)!
        
        if(!callSend) {
            items = []
            callSend = true
            APIService.getCarReservation(after: ophalenVanaf).subscribe(onNext: { reservation in
                self.items = reservation
                self.tableView.reloadData()
                self.callSend = false
                self.refreshControl.endRefreshing()
            }, onError: {error in
                self.showSnackbarDanger("error_api".localize)
                self.callSend = false
                self.refreshControl.endRefreshing()
            }).disposed(by: disposeBag)
        }
    }
    
    
    @IBAction func carReservationClick(_ sender: Any) {
        let detailVc = carStoryboard.instantiateViewController(withIdentifier:"CarReservationViewController") as! CarReservationViewController
        navigationController?.pushViewController(detailVc, animated: true)
    }
}

extension CarsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count > 0 {
            self.tableView.restore()

        } else {
            self.tableView.setEmptyMessage("car_reservation_no_results".localize)
        }
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath ) as! CustomTableViewCell
        cell.isInGrid()
        let item = items[indexPath.row]
        let formatter = DateFormatter()
        
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "EE"
        
        cell.DayLabel.text = formatter.string(from: item!.date).uppercased()
        
        formatter.dateFormat = "dd-MM"
        cell.DateLabel.text = formatter.string(from: item!.date)
        
        cell.CompanyLabel.text = "\(String(describing: item!.vehicle.brand)) \(String(describing: item!.vehicle.model)) \(item!.vehicle.transmission)"
        
        formatter.dateFormat = "HH:mm"
        cell.TimeLocationLabel.text = "\(formatter.string(from: item!.start)) - \(formatter.string(from: item!.end)), \(item!.vehicle.city)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}

extension CarsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVc = carStoryboard.instantiateViewController(withIdentifier:"CarDetailViewController") as! CarDetailViewController
        
        dateFormatter.dateFormat = "dd-MM-YYYY"
        
        let item = items[indexPath.row]
        let detailDate = dateFormatter.string(from: item!.date)
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        detailVc.item = item
        detailVc.rows = [
            DetailViewRow(title: "car_detail_licenceplate".localize, content: (item?.vehicle.licensePlate)!, icon: nil, iconClicked: {}),
            DetailViewRow(title: "car_detail_date".localize, content: (detailDate), icon: nil, iconClicked: {}),
            DetailViewRow(title: "car_detail_time".localize, content: ("\(dateFormatter.string(from: item!.start)) - \(dateFormatter.string(from: item!.end))"), icon: nil, iconClicked: {}),
            DetailViewRow(title: "car_detail_adress".localize, content: item!.vehicle.location, icon: UIImage(systemName: "arrow.up.right.diamond.fill"), iconClicked: {
                let url = URL(string: "http://maps.apple.com/?address=\(item!.vehicle.location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)")
                UIApplication.shared.open(url!)
            }),
        ]
        
        navigationController?.pushViewController(detailVc, animated: true)
    }
}
