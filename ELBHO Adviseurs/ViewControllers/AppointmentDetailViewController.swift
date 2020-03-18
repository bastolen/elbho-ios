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
    @IBOutlet weak var BottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        
        TableView.dataSource = self
        TableView.register(UINib(nibName: "DetailViewCell", bundle: nil), forCellReuseIdentifier: "DetailViewCell")
        TableView.tableFooterView = UIView()
        var yPos: CGFloat = 14
        
        buttons.forEach{ btn in
            let button = MDCButton()
            
            button.setTitle(btn.text, for:.normal)
            button.setTitleColor(.black, for: .normal)
            button.frame = CGRect(x: 10, y: yPos, width: self.view.frame.width - 20, height: 48)
            
            button.isUserInteractionEnabled = true
            button.addTapGestureRecognizer(action: btn.clicked)
            if(btn.image != nil) {
                button.setImage(btn.image, for: .normal)
                button.tintColor = .white
            }
            
            switch btn.style {
            case .primary:
                button.setPrimary()
            case .secondary:
                button.setSecondary()
            case .success:
                button.setSuccess()
            case .danger:
                button.setDanger()
            case .textPrimary:
                button.setTextPrimary()
            case .textSecondary:
                button.setTextSecondary()
            default:
                button.setPrimary()
            }
            
            BottomView.addSubview(button)
            
            yPos = yPos + 56
        }
        
        if let constraint = (BottomView.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = yPos
        }
        
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
