//
//  CarReservation.swift
//  ELBHO Adviseurs
//
//  Created by Kevin Bosma on 09/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents
import MobileCoreServices

class CarReservationViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var Calendar: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var prevMonth: UIButton!
    @IBOutlet weak var nextMonth: UIButton!
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var carReservationButton: MDCButton!
    
    @IBOutlet weak var timeFromInput: MDCTextField!
    @IBOutlet weak var timeUntilInput: MDCTextField!
    var inputTimeFromInputController: MDCTextInputControllerUnderline?
    var inputTimeFromUntilController: MDCTextInputControllerUnderline?
    
    var clickedDate = String()
    
    var items: [CarAvailability] = MockService.getCarAvailability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Auto reserveren"
        
        Calendar.dataSource = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        
        //Calendar.delegate = self
        
        currentMonth = months[month]
        monthLabel.text = "\(currentMonth) \(year)"
        
        if weekday == 0 {
            weekday = 7
        }
        
        prevMonth.imageView?.tintColor = UIColor.black
        nextMonth.imageView?.tintColor = UIColor.black
     
        getStartDateDayPosition()
        setupCollectionView()
        setupInputFields()
    }
    
    func setupInputFields()
    {
        inputTimeFromInputController = MDCTextInputControllerUnderline(textInput: timeFromInput)
        inputTimeFromInputController?.activeColor = UIColor(named: "Primary")
        
        timeFromInput.placeholderLabel.text = "Van"
        timeFromInput.placeholderLabel.textColor = UIColor(named: "Primary")!
        timeFromInput.clearButtonMode = .never
        
        inputTimeFromUntilController = MDCTextInputControllerUnderline(textInput: timeUntilInput)
        inputTimeFromUntilController?.activeColor = UIColor(named: "Primary")
        timeUntilInput.placeholderLabel.text = "Tot"
        timeUntilInput.placeholderLabel.textColor = UIColor(named: "Primary")!
        timeUntilInput.clearButtonMode = .never
        
        carReservationButton.setPrimary()
    }
    
    func setupCollectionView()
    {
        let itemSpacing: CGFloat = 5
        let itemsInOneLine: CGFloat = 7
        let flow = self.Calendar.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsets(top: itemSpacing, left: itemSpacing, bottom: itemSpacing, right: itemSpacing)
        flow.minimumInteritemSpacing = itemSpacing
        flow.minimumLineSpacing = 7
        let cellWidth = (UIScreen.main.bounds.width - (itemSpacing * 2) - ((itemsInOneLine - 1) * itemSpacing)) / itemsInOneLine
        flow.itemSize = CGSize(width: cellWidth, height: 45)
    }
    
    @IBAction func prevMonthClick(_ sender: Any) {
        switch currentMonth {
        case "Januari":
            month = 11
            year -= 1
            direction = -1
            
            getStartDateDayPosition()
            
            currentMonth = months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
        default:
            month -= 1
            direction = -1
            
            getStartDateDayPosition()
            
            currentMonth = months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
        }
    }
    
    @IBAction func nextMonthClick(_ sender: Any) {
        switch currentMonth {
        case "December":
            month = 0
            year += 1
            direction = 1
            getStartDateDayPosition()
            currentMonth = months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
        default:
            direction = 1
            getStartDateDayPosition()
            month += 1
            currentMonth = months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch direction {
        case 0:
            return daysInMonth[month] + numberOfEmptyBox + 7
        case 1:
            return daysInMonth[month] + nextNumberOfEmptyBox + 7
        case -1:
            return daysInMonth[month] + previousNumberOfEmtyBox + 7
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! CarDateCell
        cell.dateLabel.textColor = UIColor.black
        // Indexpath tussen 0-6 is week dagen tonen, MA,DI,WO etc,
        if(indexPath.row <= 6) {
            cell.dateLabel.text = daysShort[indexPath.row]
            cell.isUserInteractionEnabled = false
            cell.backgroundColor = UIColor(named: "BeschikbaarheidDateBackground")
        } else {
            // Maand directie bepalen 0 = HUIDIGE MAAND, 1 = MAAND VERDER, -1 = MAAND TERUG
            switch direction {
            case 0:
                cell.dateLabel.text = "\(indexPath.row - 6 - numberOfEmptyBox)"
            case 1:
                cell.dateLabel.text = "\(indexPath.row - 6 - nextNumberOfEmptyBox)"
            case -1:
                cell.dateLabel.text = "\(indexPath.row - 6 - previousNumberOfEmtyBox)"
            default:
                fatalError()
            }
            
            // Cell hiden wanner het 0 of negatief is
            if Int(cell.dateLabel.text!)! < 1 {
                cell.isHidden = true
            }
            
            // Kleurtje voor het weekend
            switch indexPath.row {
            case 12,13,19,20,26,27,33,34,40,41:
                if Int(cell.dateLabel.text!)! > 0 {
                    cell.dateLabel.textColor = UIColor.lightGray
                    cell.isUserInteractionEnabled = false
                }
            default:
                break
            }
        }
        return cell
    }
    
}

extension CarReservationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath ) as! CustomTableViewCell
        var item = items[indexPath.row]
        let formatter = DateFormatter()
        
        formatter.dateFormat = "EE"
        cell.DayLabel.text = formatter.string(from: item.availibleTime).uppercased()
        
        formatter.dateFormat = "dd-MM"
        cell.DateLabel.text = formatter.string(from: item.availibleTime)
        
        cell.CompanyLabel.text = item.car
        
        formatter.dateFormat = "HH:mm"
        cell.TimeLocationLabel.text = "\(formatter.string(from: item.availibleTime)) - \(formatter.string(from: item.availibleTime.addingTimeInterval(60*60))), \(item.pickupAdres)"
        
        if item.selected == true {
            cell.imageViewBackground.backgroundColor = UIColor.red
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}

extension CarReservationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].selected  = true
        tableView.reloadData()
    }
}
