//
//  AppointmentDetailViewController.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 05/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import UIKit
import MaterialComponents

class AppointmentDetailViewController: UIViewController {
    
    var buttons: [DetailViewButton] = []
    var rows: [DetailViewRow] = []
    
    @IBOutlet weak var TableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        
        TableView.dataSource = self
        TableView.register(UINib(nibName: "DetailViewCell", bundle: nil), forCellReuseIdentifier: "DetailViewCell")
        let tableFooter = UIView()
        
        var yPos: CGFloat = 0
        
        buttons.forEach{ btn in
            let button = MDCButton()
            
            button.setTitle(btn.text, for:.normal)
            button.setTitleColor(.black, for: .normal)
            button.frame = CGRect(x: 10, y: yPos, width: TableView.frame.width - 20, height: 48)
            button.setPrimary()
            button.isUserInteractionEnabled = true
            button.addTapGestureRecognizer(action: btn.clicked)
            
            tableFooter.addSubview(button)
            
            yPos = yPos + 56
        }
        
        tableFooter.frame = CGRect(x: 0, y: 0, width: TableView.frame.width, height: yPos)
        
        TableView.tableFooterView = tableFooter
        TableView.reloadData()
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
