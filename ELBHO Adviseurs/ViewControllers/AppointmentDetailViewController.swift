//
//  AppointmentDetailViewController.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 05/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import UIKit

class AppointmentDetailViewController: UIViewController {
    
    var buttons: [DetailViewButton] = []
    var rows: [DetailViewRow] = []
    
    @IBOutlet weak var TableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        
        TableView.dataSource = self
        TableView.tableFooterView = UIView()
        TableView.register(UINib(nibName: "DetailViewCell", bundle: nil), forCellReuseIdentifier: "DetailViewCell")
    }
}

extension AppointmentDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailViewCell", for: indexPath ) as! DetailViewCell
        let item = rows[indexPath.row]
        cell.titleLabel.text = item.title.uppercased()
        cell.contentLabel.text = item.content
        
        if item.icon != nil {
            cell.iconView.image = item.icon
            cell.iconView.addTapGestureRecognizer(action: item.iconClicked)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
