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
import SideMenu

class CarsViewController : UIViewController {
    
    @IBOutlet weak var bookCarButton: MDCButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let dateFormatter = DateFormatter()
    let carStoryboard = UIStoryboard(name: "Car", bundle: nil)
    
    var items: [CarReservation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Auto overzicht"
        navigationController?.navigationBar.tintColor = .white
        
        bookCarButton.setPrimary()
        mainView.layer.borderWidth = 1
        mainView.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
    }
    
    @IBAction func carReservationClick(_ sender: Any) {
        let detailVc = carStoryboard.instantiateViewController(withIdentifier:"CarReservationViewController") as! CarReservationViewController
        navigationController?.pushViewController(detailVc, animated: true)
    }
}

extension CarsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath ) as! CustomTableViewCell
        let item = items[indexPath.row]
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "EE"
        cell.DayLabel.text = formatter.string(from: item.reservationDate).uppercased()
        
        formatter.dateFormat = "dd-MM"
        cell.DateLabel.text = formatter.string(from: item.reservationDate)
        cell.CompanyLabel.text = item.car
        cell.iconView.image = nil
        
        formatter.dateFormat = "HH:mm"
        cell.TimeLocationLabel.text = "\(formatter.string(from: item.reservationDate)) - \(formatter.string(from: item.reservationDate.addingTimeInterval(60*60))), \(item.pickupPlace)"
        
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
        detailVc.item = item
        detailVc.rows = [
            DetailViewRow(title: "Kenteken", content: item.licencePlate, icon: nil, iconClicked: {}),
            DetailViewRow(title: "Datum", content: dateFormatter.string(from: item.reservationDate), icon: nil, iconClicked: {}),
            DetailViewRow(title: "Tijd", content: "09:00 - 14:00", icon: nil, iconClicked: {}),
            DetailViewRow(title: "Adres", content: item.pickupAdres, icon: UIImage(named: "RouteIcon"), iconClicked: {
                let url = URL(string: "http://maps.apple.com/?address=\(item.pickupAdres.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)")
                UIApplication.shared.open(url!)
            }),
        ]
        
        navigationController?.pushViewController(detailVc, animated: true)
    }
}
