//
//  CopyWeekViewController.swift
//  ELBHO Adviseurs
//
//  Created by Kevin Bosma on 06/01/2020.
//  Copyright © 2020 Otters. All rights reserved.
//

import UIKit
import RxSwift
import SwiftKeychainWrapper
import MaterialComponents
class CopyWeekViewController : UIViewController {
    
    let nc = NotificationCenter.default
    let dateFormatter = DateFormatter()
    
    var weekToCopy = Int()
    var weeks : [Int] = []
    var daysFromWeekToCopy: [Availability?] = []
    var daysToApi : [Availability2] = []
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var weekToCopyLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    private var callSend: Bool = false
    
    // LABELS
    var labels : [UILabel] = []
    @IBOutlet weak var weekLabel1: UILabel!
    @IBOutlet weak var weekLabel2: UILabel!
    @IBOutlet weak var weekLabel3: UILabel!
    @IBOutlet weak var weekLabel4: UILabel!
    @IBOutlet weak var weekLabel5: UILabel!
    @IBOutlet weak var weekLabel6: UILabel!
    @IBOutlet weak var weekLabel7: UILabel!
    @IBOutlet weak var weekLabel8: UILabel!
    
    // SWITCHES
    var switches : [UISwitch] = []
    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var switch2: UISwitch!
    @IBOutlet weak var switch3: UISwitch!
    @IBOutlet weak var switch4: UISwitch!
    @IBOutlet weak var switch5: UISwitch!
    @IBOutlet weak var switch6: UISwitch!
    @IBOutlet weak var switch7: UISwitch!
    @IBOutlet weak var switch8: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beschikbaarheid"
        navigationController?.navigationBar.tintColor = .white
        
        mainView.layer.borderWidth = 1
        mainView.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        
        weekToCopyLabel.text = "Week "+String(weekToCopy)+" kopieren naar"
        
        setArrays()
        fillLabels()
    }
    
    func setArrays()
    {
        labels.append(weekLabel1)
        labels.append(weekLabel2)
        labels.append(weekLabel3)
        labels.append(weekLabel4)
        labels.append(weekLabel5)
        labels.append(weekLabel6)
        labels.append(weekLabel7)
        labels.append(weekLabel8)
        
        switches.append(switch1)
        switches.append(switch2)
        switches.append(switch3)
        switches.append(switch4)
        switches.append(switch5)
        switches.append(switch6)
        switches.append(switch7)
        switches.append(switch8)
        
        for i in 0..<labels.count {
            weeks.append((weekToCopy+i+1))
        }
    }
    
    func fillLabels()
    {
        if labels.count > 0 {
            for i in 0..<labels.count {
                labels[i].text = "Week "+String(weeks[i])
            }
        }
    }
    
    @IBAction func copyWeekClick(_ sender: Any) {
        for i in 0..<switches.count {
            if switches[i].isOn {
                // Verschil tussen kopierende week en geselecteerde week
                let weeksDiff = weeks[i] - weekToCopy
                let daysToAdd = weeksDiff * 7
                
                for item in daysFromWeekToCopy {
                    let date = Calendar.current.date(byAdding: .day, value: daysToAdd, to: item!.date)!
                    let start = Calendar.current.date(byAdding: .day, value: daysToAdd, to: item!.start)!
                    let end = Calendar.current.date(byAdding: .day, value: daysToAdd, to: item!.end)!
                    
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                    
                    let a = Availability2(
                        date: dateFormatter.string(from: date),
                        start: dateFormatter.string(from: start),
                        end: dateFormatter.string(from: end))
                    
                    daysToApi.append(a)
                }
            }
        }
        
        sendItemsToAPI(sendItems: daysToApi)
    }
    
    private func sendItemsToAPI(sendItems : [Availability2]) {
        if(!callSend) {
            callSend = true
            APIService.postAvailability(availabilities: sendItems).subscribe(onNext: {
                self.showSnackbarSuccess("De beschikbaarheid is ingevoerd.")
                self.callSend = false
            }, onError: {error in
                self.showSnackbarDanger("error_api".localize)
                self.callSend = false
            }).disposed(by: disposeBag)
        }
        
        _ = navigationController?.popViewController(animated: true)
        nc.post(name: Notification.Name("reloadAvailibility"), object: nil)
    }
}
