//
//  InvoiceViewController.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 06/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import UIKit
import MaterialComponents

class InvoiceViewController: UIViewController {
    
    @IBOutlet weak var TopLabel: UILabel!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var AddButton: MDCButton!

    let refreshControl = UIRefreshControl()
    var items: [Invoice] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "title_invoice".localize
        TopLabel.text = "invoice_header".localize
        
        TableView.dataSource = self
        TableView.delegate = self
        TableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        
        TableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .allEvents)
        
        AddButton.setPrimary()
        AddButton.setTitle("button_addinvoice".localize, for: .normal)
    }
    
    @IBAction func AddButtonClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Invoice", bundle: nil)
        let addVc = storyboard.instantiateViewController(withIdentifier: "AddInvoiceViewController") as! AddInvoiceViewController
        self.navigationController?.pushViewController(addVc, animated: true)
    }
    
    @objc func refresh() {
        TableView.reloadData()
        self.refreshControl.endRefreshing()
    }
}

extension InvoiceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath ) as! CustomTableViewCell
        let item = items[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM"
        
        cell.TimeLocationLabel.text = "\("upload_date".localize): \(formatter.string(from: item.UploadDate))"
        cell.CompanyLabel.text = item.FileName
        formatter.dateFormat = "MMM"
        cell.DayLabel.text = formatter.string(from: item.UploadDate)
        formatter.dateFormat = "yyyy"
        cell.DateLabel.text = formatter.string(from: item.UploadDate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}

extension InvoiceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        print(item)
    }
}
