//
//  InvoiceViewController.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 06/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import UIKit
import MaterialComponents
import RxSwift

class InvoiceViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var TopLabel: UILabel!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var AddButton: MDCButton!
    
    private var callSend: Bool = false
    let refreshControl = UIRefreshControl()
    var items: [Invoice?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "title_invoice".localize
        TopLabel.text = "invoice_header".localize
        
        mainView.layer.borderWidth = 1
        mainView.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        
        TableView.dataSource = self
        TableView.delegate = self
        TableView.tableFooterView = UIView()
        TableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        
        TableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .allEvents)
        
        AddButton.setPrimary()
        AddButton.setTitle("button_addinvoice".localize, for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: Notification.Name("refreshInvoices"), object: nil)
        initMenu(id: 5)
        initContent()
    }
    /**
     Get the data from the api and display it in the tableview
     */
    private func initContent() {
        if(!callSend) {
            refreshControl.beginRefreshing()
            TableView.reloadData()
            callSend = true
            APIService.getInvoices().subscribe(onNext: { invoices in
                self.items = invoices
                self.callSend = false
                self.TableView.reloadData()
                self.refreshControl.endRefreshing()
            }, onError: {error in
                self.showSnackbarDanger("error_api".localize)
                self.callSend = false
            }).disposed(by: disposeBag)
        }
    }
    
    /**
     Open the add invoice VC to be able to add a new invoice to this list
     */
    @IBAction func AddButtonClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Invoice", bundle: nil)
        let addVc = storyboard.instantiateViewController(withIdentifier: "AddInvoiceViewController") as! AddInvoiceViewController
        self.navigationController?.pushViewController(addVc, animated: true)
    }
    
    /**
     Function called when pulling down or when a new invoice is added
     */
    @objc func refresh() {
        initContent()
    }
}

extension InvoiceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count > 0 {
            self.TableView.restore()
        } else {
            self.TableView.setEmptyMessage("invoices_no_results".localize)
        }
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath ) as! CustomTableViewCell
        let item = items[indexPath.row]!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        cell.isInGrid()
        cell.TimeLocationLabel.text = "upload_date".localizeWithVars(formatter.string(from: item.Date))
        cell.CompanyLabel.text = item.FileName
        formatter.dateFormat = "MMM"
        cell.DayLabel.text = formatter.string(from: item.InvoiceMonth).uppercased()
        formatter.dateFormat = "yyyy"
        cell.DateLabel.text = formatter.string(from: item.InvoiceMonth)
        cell.iconView.image = UIImage(named: "DownloadIcon")
        cell.iconView.addTapGestureRecognizer(action: {
            let pdfViewer = UIStoryboard(name: "Invoice", bundle: nil).instantiateViewController(identifier: "PDFViewController") as! PDFViewController
            pdfViewer.pdfLink = item.FilePath
            
            self.present(pdfViewer, animated: true)
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}

extension InvoiceViewController: UITableViewDelegate {
}
