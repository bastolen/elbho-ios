//
//  CarReservation.swift
//  ELBHO Adviseurs
//
//  Created by Kevin Bosma on 09/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import RxSwift
import Foundation
import UIKit
import MaterialComponents
import MobileCoreServices

class CarReservationViewController : UIViewController {
    
    let nc = NotificationCenter.default
    
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
    var checkDate = String()
    var highLighted = -1
    var items: [CarAvailability?] = []
    let dateFormatter = DateFormatter()
    
    // UI ELEMENTEN
    var datePicker = UIDatePicker()
    let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(dismissPicker))
    
    private let disposeBag = DisposeBag()
    private var callSend: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "vehicle".localize
        carReservationButton.setTitle("button_car_reservation".localize.uppercased(), for: .normal)
        resetVars()
        
        Calendar.dataSource = self
        Calendar.layer.borderWidth = 1
        Calendar.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        
        Calendar.delegate = self
        
        currentMonth = months[month]
        monthLabel.text = "\(currentMonth) \(year)"
        
        if weekday == 0 {
            weekday = 7
        }
        
        prevMonth.imageView?.tintColor = UIColor.black
        nextMonth.imageView?.tintColor = UIColor.black
     
        dateFormatter.dateFormat =  "HH:mm"
        
        datePicker.minimumDate = dateFormatter.date(from: "06:00")!
        datePicker.maximumDate = dateFormatter.date(from: "22:00")!
        datePicker.date = dateFormatter.date(from: "10:00")!
        datePicker.datePickerMode = .time
        datePicker.minuteInterval = 15
        
        getStartDateDayPosition()
        setupCollectionView()
        setupInputFields()
    }
    
    func setupInputFields()
    {
        inputTimeFromInputController = MDCTextInputControllerUnderline(textInput: timeFromInput)
        inputTimeFromInputController?.activeColor = UIColor(named: "Primary")
        
        timeFromInput.placeholderLabel.text = "from".localize
        timeFromInput.placeholderLabel.textColor = UIColor(named: "Primary")!
        timeFromInput.clearButtonMode = .never
        
        inputTimeFromUntilController = MDCTextInputControllerUnderline(textInput: timeUntilInput)
        inputTimeFromUntilController?.activeColor = UIColor(named: "Primary")
        timeUntilInput.placeholderLabel.text = "until".localize
        timeUntilInput.placeholderLabel.textColor = UIColor(named: "Primary")!
        timeUntilInput.clearButtonMode = .never
        
        
        timeFromInput.inputView = datePicker
        timeFromInput.inputAccessoryView = toolBar
        timeUntilInput.inputView = datePicker
        timeUntilInput.inputAccessoryView = toolBar
        
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
        flow.itemSize = CGSize(width: cellWidth-6, height: 43)
    }
    
    @objc func dismissPicker() {
        dateFormatter.dateFormat = "HH:mm"
        let pickedTime = dateFormatter.string(from: datePicker.date)
        
        if timeFromInput.isFirstResponder {
            if !timeUntilInput.text!.isEmpty {
                let check = dateFormatter.date(from: timeUntilInput.text!)!
                datePicker.date.isBeforeOrEquel(check) ? timeFromInput.text = pickedTime : self.showSnackbarSecondary("time_bigger".localize)
            } else {
                timeFromInput.text = pickedTime
            }
        } else if timeUntilInput.isFirstResponder {
            if !timeFromInput.text!.isEmpty {
                let check = dateFormatter.date(from: timeFromInput.text!)!
                !datePicker.date.isBeforeOrEquel(check) ? timeUntilInput.text = pickedTime : self.showSnackbarSecondary("time_bigger".localize)
            } else {
                timeUntilInput.text = pickedTime
            }
        }
        
        view.endEditing(true)
        getCars()
    }
    
    func getCars()
    {
        if !clickedDate.isEmpty && !timeFromInput.text!.isEmpty && !timeUntilInput.text!.isEmpty {
            initContent()
        }
    }
    
    private func initContent() {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let show = formatter.date(from: clickedDate)
        let dateSend = formatter.string(from: show!)
        if(!callSend) {
            items = []
            callSend = true
            APIService.getCarsAvailability(date: dateSend).subscribe(onNext: { cars in
                self.items = cars
                self.tableView.reloadData()
                self.callSend = false
            }, onError: {error in
                self.showSnackbarDanger("error_api".localize)
                self.callSend = false
            }).disposed(by: disposeBag)
        }
    }
    
    @IBAction func makeCarReservation(_ sender: Any) {
        
        if(timeFromInput.text!.isEmpty || timeUntilInput.text!.isEmpty) {
            self.showSnackbarDanger("car_invalid_fields".localize)
        } else {
            dateFormatter.dateFormat = "YYYY-MM-dd"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            let clickedInFormat = dateFormatter.date(from: clickedDate)
            let clickedInString = dateFormatter.string(from: clickedInFormat!)
            var car = String()
            
            for c in items {
                if c?.selected == true {
                    car = c!._id
                }
            }
            
            if(!callSend) {
                callSend = true
                APIService.postCarReservation(
                    vehicle: car,
                    date: clickedInString+"T00:00:00.000Z",
                    start: clickedInString+"T"+timeFromInput.text!+":00.000Z",
                    end: clickedInString+"T"+timeUntilInput.text!+":00.000Z")
                    .subscribe(onNext: {
                    self.showSnackbarSuccess("car_taken".localize)
                    self.callSend = false
                    self.nc.post(name: Notification.Name("reloadCarReservations"), object: nil)
                    self.navigationController?.popViewController(animated: true)
                }, onError: {error in
                    self.showSnackbarDanger("error_api".localize)
                    self.callSend = false
                }).disposed(by: disposeBag)
            }
            
        }
    }
    
    @IBAction func prevMonthClick(_ sender: Any) {
        highLighted = -1
        switch currentMonth {
        case "month_1".localize:
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
        highLighted = -1
        switch currentMonth {
        case "month_12".localize:
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
    
}

extension CarReservationViewController : UICollectionViewDelegate, UICollectionViewDataSource {
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
            } else {
                dateFormatter.dateFormat = "YYYY-MM-dd"
                
                if((indexPath.row-6) - positionIndex) < 10 {
                    checkDate = "\(year)-0\(month+1)-0\((indexPath.row-6) - positionIndex)"
                } else {
                    checkDate = "\(year)-0\(month+1)-\((indexPath.row-6) - positionIndex)"
                }
                
                let today = Date()
                if dateFormatter.date(from: checkDate)!.isBefore(today) {
                    cell.backgroundColor = UIColor(named: "BorderColor")
                    cell.isUserInteractionEnabled = false
                    cell.dateLabel.textColor = UIColor.lightGray
                } else {
                    if highLighted == indexPath.row {
                        cell.backgroundColor = UIColor.init(named: "ActiveCellColor")!
                    }
                }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        clickedDate = "\(year)-\(month+1)-\((indexPath.row-6) - positionIndex)"
        highLighted = indexPath.row
        collectionView.reloadData()
        getCars()
    }
}

extension CarReservationViewController: UITableViewDataSource {
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
        let item = items[indexPath.row]
        
        let formatter = DateFormatter()
        
        cell.isUserInteractionEnabled = true
        formatter.dateFormat = "YYYY-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let show = formatter.date(from: clickedDate)
        formatter.dateFormat = "EE"
        cell.DayLabel.text = formatter.string(from: show!).uppercased()
        
        formatter.dateFormat = "dd-MM"
        cell.DateLabel.text = formatter.string(from: show!)
        
        cell.CompanyLabel.text =  "\(String(describing: item!.brand)) \(String(describing: item!.model))"
        cell.TimeLocationLabel.text = "\(String(describing: timeFromInput.text!)) - \(String(describing: timeUntilInput.text!)) - \(item!.location)"
        
        if item!.selected == true {
            cell.imageViewBackground.backgroundColor = UIColor(named: "Secondary")
        }
        
        cell.TimeLocationLabel.numberOfLines = 1
        
        // Nu kijken of de auto wel beschikbaar is in de aangegeven tijden
        if !checkAvailability(reservations: item!.reservations) {
            cell.isUserInteractionEnabled = false
            cell.TimeLocationLabel.text = "Gereserveerd:"
            formatter.dateFormat = "HH:mm"
            for reservation in item!.reservations {
                //label.text = (label.text ?? "") + " some other word(s)"
                cell.TimeLocationLabel.text = (cell.TimeLocationLabel.text ?? "") + "\n" + formatter.string(from: reservation.start) + " - " + formatter.string(from: reservation.end)
            }
            
            cell.TimeLocationLabel.numberOfLines = 0
            cell.imageViewBackground.backgroundColor = UIColor.darkGray
        }
        
        return cell
    }
    
    func checkAvailability(reservations: [CarReservations]) -> Bool
    {
        var beschikbaar = true

        if reservations.count > 0 { //Calendar.current.date(byAdding: .hour, value: 1, to: start)!
            dateFormatter.dateFormat = "HH:mm"
            let from = calendar.date(byAdding: .hour, value: 1, to: dateFormatter.date(from: timeFromInput.text!)!)
            let until = calendar.date(byAdding: .hour, value: 1, to: dateFormatter.date(from: timeUntilInput.text!)!)
            
            for reservation in reservations {
                let start = dateFormatter.date(from: dateFormatter.string(from: reservation.start))
                let end = dateFormatter.date(from: dateFormatter.string(from: reservation.end))
                
                if from! == start! || until! == end! || from! > start! && from! < end! || until! > start! && until! < end! || from! < start! && until! > end! {
                    beschikbaar = false
                }
            }
            
        } else {
            beschikbaar = true
        }
        
        return beschikbaar
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = items[indexPath.row]
        
        if !checkAvailability(reservations: item!.reservations) {
            if (item?.reservations.count)! > 1 {
                // 20
                let t = item?.reservations.count
                
                return CGFloat(96 + ((t!-1) * 20))
            } else {
                return 96
            }
        } else {
            return 96
        }
    }
}

extension CarReservationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for i in 0..<items.count {
            items[i]!.selected = i == indexPath.row
        }
        
        tableView.reloadData()
    }
}
