//
//  WeekOverzichtViewController.swift
//  ELBHO Adviseurs
//
//  Created by Kevin Bosma on 05/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import UIKit
import RxSwift
import SwiftKeychainWrapper
import MaterialComponents

class WeekOverzichtViewController: UIViewController {

    let nc = NotificationCenter.default
    
    var clickedDate = String()
    var weeknumberClickedDate = Int()
    var formattedDate = Date()
    
    var firstDate = String()
    var lastDate = String()
    
    let dateFormatter = DateFormatter()
    let calendar = Calendar.current
    
    // UI ELEMENTEN
    var datePicker = UIDatePicker()
    let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(dismissPicker))
    
    @IBOutlet weak var weekView: UIView!
    @IBOutlet weak var weekNumberLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var untilLabel: UILabel!
    
    
    // Dag 1
    @IBOutlet weak var dayLabelDay1: UILabel!
    @IBOutlet weak var dateLabelDay1: UILabel!
    @IBOutlet weak var timeInputDay1From: UITextField!
    @IBOutlet weak var timeInputDay1Until: UITextField!
    
    // Dag 2
    @IBOutlet weak var dayLabelDay2: UILabel!
    @IBOutlet weak var dateLabelDay2: UILabel!
    @IBOutlet weak var timeInputDay2From: UITextField!
    @IBOutlet weak var timeInputDay2Until: UITextField!
    
    // Dag 3
    @IBOutlet weak var dayLabelDay3: UILabel!
    @IBOutlet weak var dateLabelDay3: UILabel!
    @IBOutlet weak var timeInputDay3From: UITextField!
    @IBOutlet weak var timeInputDay3Until: UITextField!
    
    
    // Dag 4
    @IBOutlet weak var dayLabelDay4: UILabel!
    @IBOutlet weak var dateLabelDay4: UILabel!
    @IBOutlet weak var timeInputDay4From: UITextField!
    @IBOutlet weak var timeInputDay4Until: UITextField!
    
    // Dag 5
    @IBOutlet weak var dayLabelDay5: UILabel!
    @IBOutlet weak var dateLabelDay5: UILabel!
    @IBOutlet weak var timeInputDay5From: UITextField!
    @IBOutlet weak var timeInputDay5Until: UITextField!
    
    @IBOutlet weak var buttonCopyWeek: UIButton!
    @IBOutlet weak var buttonSaveWeek: UIButton!
    
    // API Vars
    private let disposeBag = DisposeBag()
    var items: [Availability?] = []
    var sendItems : [Availability2] = []
    
    private var callSend: Bool = false
    var daysToShow: [Date] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "title_availability".localize
        formattedDate = formatStringToDate(toFormat: clickedDate)
        weekNumberLabel.text = "week".localize+" "+String(getWeekNumber(date: formattedDate))
        
        buttonCopyWeek.setTitle("button_copy_week".localize.uppercased(), for: .normal)
        buttonSaveWeek.setTitle("button_save_week".localize.uppercased(), for: .normal)
        fromLabel.text = "from".localize
        untilLabel.text = "until".localize
        
        weekView.layer.borderWidth = 1
        weekView.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        buttonCopyWeek.layer.borderWidth = 1
        buttonCopyWeek.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        
        // Datepicker opties
        dateFormatter.dateFormat =  "HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        // Min en max tijd voor datepicker
        datePicker.minimumDate = dateFormatter.date(from: "06:00")!
        datePicker.maximumDate = dateFormatter.date(from: "22:00")!
        
        // Startijd instellen
        datePicker.date = dateFormatter.date(from: "08:00")!
        datePicker.timeZone = TimeZone(abbreviation: "UTC")
        datePicker.datePickerMode = .time
        datePicker.minuteInterval = 15
        
        /**
         Dag bij deze week ophalen aan de hand van het doorgegeven weeknummer
         */
        daysToShow = getDays()

        setTimeInput()
        fillLabelsAndInput()
        
        initContent()
    }
    
    /**
     Get data from API and set time fields
     */
    private func initContent() {
        if(!callSend) {
            items = []
            callSend = true
            APIService.getAvailability(after: firstDate, before: lastDate).subscribe(onNext: { availability in
                self.items = availability
                self.setTimeInput()
                self.callSend = false
            }, onError: {error in
                self.showSnackbarDanger("error_api".localize)
                self.callSend = false
            }).disposed(by: disposeBag)
        }
    }
    
    /**
     Function to fill the date labels
     */
    func fillLabelsAndInput()
    {
        // Checken of er wel 5 dagen zijn doorgekomen
        if daysToShow.count == 5 {
            /**
             Fill 2 vars for the API call
             */
            dateFormatter.dateFormat = "YYYY-MM-dd"
            firstDate = dateFormatter.string(from: daysToShow[0])
            lastDate = dateFormatter.string(from: daysToShow[4])
            
            // Nu de labels vullen
            dateFormatter.dateFormat = "dd-MM-YY"
            dateLabelDay1.text = dateFormatter.string(from: daysToShow[0])
            dateLabelDay2.text = dateFormatter.string(from: daysToShow[1])
            dateLabelDay3.text = dateFormatter.string(from: daysToShow[2])
            dateLabelDay4.text = dateFormatter.string(from: daysToShow[3])
            dateLabelDay5.text = dateFormatter.string(from: daysToShow[4])
            
            dayLabelDay1.text = "day_1_small".localize
            dayLabelDay2.text = "day_2_small".localize
            dayLabelDay3.text = "day_3_small".localize
            dayLabelDay4.text = "day_4_small".localize
            dayLabelDay5.text = "day_5_small".localize
        }
        
    }
    
    /**
     Set all input fields with API response
     */
    func setTimeInput()
    {
        var response = [String]()
        // datePicker zetten op Text fields
        response = getInfoByDate(index: 0)
        timeInputDay1From.inputView = datePicker
        timeInputDay1From.inputAccessoryView = toolBar
        timeInputDay1Until.inputView = datePicker
        timeInputDay1Until.inputAccessoryView = toolBar
        if response.count == 2 {
            timeInputDay1From.text = response[0]
            timeInputDay1Until.text = response[1]
        }
        
        response = getInfoByDate(index: 1)
        timeInputDay2From.inputView = datePicker
        timeInputDay2From.inputAccessoryView = toolBar
        timeInputDay2Until.inputView = datePicker
        timeInputDay2Until.inputAccessoryView = toolBar
        if response.count == 2 {
            timeInputDay2From.text = response[0]
            timeInputDay2Until.text = response[1]
        }
        response = getInfoByDate(index: 2)
        timeInputDay3From.inputView = datePicker
        timeInputDay3From.inputAccessoryView = toolBar
        timeInputDay3Until.inputView = datePicker
        timeInputDay3Until.inputAccessoryView = toolBar
        if response.count == 2 {
            timeInputDay3From.text = response[0]
            timeInputDay3Until.text = response[1]
        }
        
        response = getInfoByDate(index: 3)
        timeInputDay4From.inputView = datePicker
        timeInputDay4From.inputAccessoryView = toolBar
        timeInputDay4Until.inputView = datePicker
        timeInputDay4Until.inputAccessoryView = toolBar
        if response.count == 2 {
            timeInputDay4From.text = response[0]
            timeInputDay4Until.text = response[1]
        }
        
        response = getInfoByDate(index: 4)
        timeInputDay5From.inputView = datePicker
        timeInputDay5From.inputAccessoryView = toolBar
        timeInputDay5Until.inputView = datePicker
        timeInputDay5Until.inputAccessoryView = toolBar
        if response.count == 2 {
            timeInputDay5From.text = response[0]
            timeInputDay5Until.text = response[1]
        }
        
    }
    
    /**
     Function to get the API response row by index
     */
    func getInfoByDate(index : Int) -> [String]
    {
        var values = [String]()
        var search = String()
        
        dateFormatter.dateFormat = "YYYY-MM-dd"
        search = dateFormatter.string(from: daysToShow[index])
        
        for item in items {
            if dateFormatter.string(for: item?.date) == search {
                dateFormatter.dateFormat = "HH:mm"
                values = [dateFormatter.string(from: item!.start), dateFormatter.string(from: item!.end)]
            }
        }
        
        return values
    }
    
    /**
     Add times to input fields when picker is dismissed
     */
    @objc func dismissPicker() {

        dateFormatter.dateFormat = "HH:mm"
        let pickedTime = dateFormatter.string(from: datePicker.date)
        
        if timeInputDay1From.isFirstResponder {
            if !timeInputDay1Until.text!.isEmpty {
                let check = dateFormatter.date(from: timeInputDay1Until.text!)!
                datePicker.date.isBeforeOrEqual(check) ? timeInputDay1From.text = pickedTime : self.showSnackbarSecondary("time_bigger".localize)
            } else {
                timeInputDay1From.text = pickedTime
            }
        } else if timeInputDay1Until.isFirstResponder {
            if !timeInputDay1From.text!.isEmpty {
                let check = dateFormatter.date(from: timeInputDay1From.text!)!
                !datePicker.date.isBeforeOrEqual(check) ? timeInputDay1Until.text = pickedTime : self.showSnackbarSecondary("time_smaller".localize)
            } else {
                timeInputDay1Until.text = pickedTime
            }
        } else if timeInputDay2From.isFirstResponder {
            if !timeInputDay2Until.text!.isEmpty {
                let check = dateFormatter.date(from: timeInputDay2Until.text!)!
                datePicker.date.isBeforeOrEqual(check) ? timeInputDay2From.text = pickedTime : self.showSnackbarSecondary("time_bigger".localize)
            } else {
                timeInputDay2From.text = pickedTime
            }
        } else if timeInputDay2Until.isFirstResponder {
            if !timeInputDay2From.text!.isEmpty {
                let check = dateFormatter.date(from: timeInputDay2From.text!)!
                !datePicker.date.isBeforeOrEqual(check) ? timeInputDay2Until.text = pickedTime : self.showSnackbarSecondary("time_smaller".localize)
            } else {
                timeInputDay2Until.text = pickedTime
            }
        } else if timeInputDay3From.isFirstResponder {
            if !timeInputDay3Until.text!.isEmpty {
                let check = dateFormatter.date(from: timeInputDay3Until.text!)!
                datePicker.date.isBeforeOrEqual(check) ? timeInputDay3From.text = pickedTime : self.showSnackbarSecondary("time_bigger".localize)
            } else {
                timeInputDay3From.text = pickedTime
            }
        } else if timeInputDay3Until.isFirstResponder {
            if !timeInputDay3From.text!.isEmpty {
                let check = dateFormatter.date(from: timeInputDay3From.text!)!
                !datePicker.date.isBeforeOrEqual(check) ? timeInputDay3Until.text = pickedTime : self.showSnackbarSecondary("time_smaller".localize)
            } else {
                timeInputDay3Until.text = pickedTime
            }
        } else if timeInputDay4From.isFirstResponder {
            if !timeInputDay4Until.text!.isEmpty {
                let check = dateFormatter.date(from: timeInputDay4Until.text!)!
                datePicker.date.isBeforeOrEqual(check) ? timeInputDay4From.text = pickedTime : self.showSnackbarSecondary("time_bigger".localize)
            } else {
                timeInputDay4From.text = pickedTime
            }
        } else if timeInputDay4Until.isFirstResponder {
            if !timeInputDay4From.text!.isEmpty {
                let check = dateFormatter.date(from: timeInputDay4From.text!)!
                !datePicker.date.isBeforeOrEqual(check) ? timeInputDay4Until.text = pickedTime : self.showSnackbarSecondary("time_smaller".localize)
            } else {
                timeInputDay4Until.text = pickedTime
            }
        } else if timeInputDay5From.isFirstResponder {
            if !timeInputDay5Until.text!.isEmpty {
                let check = dateFormatter.date(from: timeInputDay5Until.text!)!
                datePicker.date.isBeforeOrEqual(check) ? timeInputDay5From.text = pickedTime : self.showSnackbarSecondary("time_bigger".localize)
            } else {
                timeInputDay5From.text = pickedTime
            }
        } else if timeInputDay5Until.isFirstResponder {
            if !timeInputDay5From.text!.isEmpty {
                let check = dateFormatter.date(from: timeInputDay5From.text!)!
                !datePicker.date.isBeforeOrEqual(check) ? timeInputDay5Until.text = pickedTime : self.showSnackbarSecondary("time_smaller".localize)
            } else {
                timeInputDay5Until.text = pickedTime
            }
        }
        
        view.endEditing(true)

    }
    
    /**
     Get days by week number
     */
    func getDays() -> [Date]
    {
        let today = formattedDate
        let dayOfWeek = calendar.component(.weekday, from: today)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
            .filter { !calendar.isDateInWeekend($0) }
        
        return days
    }
    
    func formatStringToDate(toFormat: String) -> Date {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formatted = dateFormatter.date(from: toFormat)
        
        let finalDate = calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour], from: formatted!))!
        
        return finalDate
    }
    
    @IBAction func copyWeekClick(_ sender: Any) {
        /**
         Show alert with info on first time clicking the Copy Week button
         */
        if (!KeychainWrapper.standard.hasValue(forKey: "onboarding-copy-week")) {
            let alert = UIAlertController(title: "week_copy".localize, message: "week_copy_info".localize, preferredStyle: .alert)
            let imageView = UIImageView(frame: CGRect(x: 10, y: 110, width: 250, height: 125))
            imageView.image = UIImage(named: "KopieerWeekAlert")
            alert.view.addSubview(imageView)
            
            let height = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
            let width = NSLayoutConstraint(item: alert.view!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
            alert.view.addConstraint(height)
            alert.view.addConstraint(width)
            alert.addAction(UIAlertAction(title: "understand".localize, style: .default, handler: { (action) in
                KeychainWrapper.standard.set(true, forKey: "onboarding-copy-week")
            }))
            self.present(alert, animated: true)
            return
        }
        
        // Setup naar andere scherm
        let storyboard = UIStoryboard(name: "Beschikbaarheid", bundle: nil)
        let Vc = storyboard.instantiateViewController(withIdentifier: "CopyWeekViewController") as! CopyWeekViewController
        Vc.weekToCopy = getWeekNumber(date: formattedDate)
        Vc.daysFromWeekToCopy = items
        Vc.datesToShow = daysToShow
        self.navigationController?.pushViewController(Vc, animated: true)
        
        
    }
    
    @IBAction func saveWeekClick(_ sender: Any) {
        sendItems.removeAll()
        
        var from = String()
        var until = String()
        
        for (index, day) in daysToShow.enumerated() {
            if index == 0 {
                from = timeInputDay1From.text!
                until = timeInputDay1Until.text!
                
                if !from.isEmpty && !until.isEmpty {
                    sendItems.append(createAvailabilityObject(from: from, until: until, date: day, empty: false))
                } else {
                    sendItems.append(createAvailabilityObject(from: from, until: until, date: day, empty: true))
                }
            } else if index == 1 {
                from = timeInputDay2From.text!
                until = timeInputDay2Until.text!
                
                if !from.isEmpty && !until.isEmpty {
                    sendItems.append(createAvailabilityObject(from: from, until: until, date: day, empty: false))
                } else {
                    sendItems.append(createAvailabilityObject(from: from, until: until, date: day, empty: true))
                }
            } else if index == 2 {
                from = timeInputDay3From.text!
                until = timeInputDay3Until.text!
                
                if !from.isEmpty && !until.isEmpty {
                    sendItems.append(createAvailabilityObject(from: from, until: until, date: day, empty: false))
                } else {
                    sendItems.append(createAvailabilityObject(from: from, until: until, date: day, empty: true))
                }
            } else if index == 3 {
                from = timeInputDay4From.text!
                until = timeInputDay4Until.text!
                
                if !from.isEmpty && !until.isEmpty {
                    sendItems.append(createAvailabilityObject(from: from, until: until, date: day, empty: false))
                } else {
                    sendItems.append(createAvailabilityObject(from: from, until: until, date: day, empty: true))
                }
            } else if index == 4 {
                from = timeInputDay5From.text!
                until = timeInputDay5Until.text!
                
                if !from.isEmpty && !until.isEmpty {
                    sendItems.append(createAvailabilityObject(from: from, until: until, date: day, empty: false))
                } else {
                    sendItems.append(createAvailabilityObject(from: from, until: until, date: day, empty: true))
                }
            }
        }
        
        sendItemsToAPI(sendItems: sendItems)
    }
    
    private func sendItemsToAPI(sendItems : [Availability2]) {
        if(!callSend) {
            callSend = true
            APIService.postAvailability(availabilities: sendItems).subscribe(onNext: {
                self.showSnackbarSuccess("availability_succes".localize)
                self.callSend = false
                self.nc.post(name: Notification.Name("reloadAvailibility"), object: nil)
                self.navigationController?.popViewController(animated: true)
            }, onError: {error in
                self.showSnackbarDanger("error_api".localize)
                self.callSend = false
            }).disposed(by: disposeBag)
        }
    }
    
    
    func createAvailabilityObject(from : String, until : String, date : Date, empty: Bool) -> Availability2 {
        // Eerst de normale date
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let dateToSend = dateFormatter.string(from: date)
        var startToSend = String()
        var endToSend = String()
        
        if empty {
            startToSend = dateFormatter.string(from: date)
            endToSend = dateFormatter.string(from: date)
        } else {
            startToSend = dateFormatter.string(from: date)+" "+from
            endToSend = dateFormatter.string(from: date)+" "+until
        }
        
        let a = Availability2(date: dateToSend, start: startToSend, end: endToSend)
        return a
    }
    
    // Buttons to clear inputs
    @IBAction func trashDay1(_ sender: Any) {
        timeInputDay1From.text = ""
        timeInputDay1Until.text = ""
    }
    
    @IBAction func trashDay2(_ sender: Any) {
        timeInputDay2From.text = ""
        timeInputDay2Until.text = ""
    }
    
    @IBAction func trashDay3(_ sender: Any) {
        timeInputDay3From.text = ""
        timeInputDay3Until.text = ""
    }
    
    @IBAction func trashDay4(_ sender: Any) {
        timeInputDay4From.text = ""
        timeInputDay4Until.text = ""
    }
    
    @IBAction func trashDay5(_ sender: Any) {
        timeInputDay5From.text = ""
        timeInputDay5Until.text = ""
    }
    
    
    func getWeekNumber(date: Date) -> Int {
        let weekOfYear = calendar.component(.weekOfYear, from: date)
        return weekOfYear
    }
    
    func getDayNumber(date: Date) -> Int {
        let component = calendar.dateComponents([.weekday], from: date)
        return component.weekday!
    }
}


extension UIToolbar {
    func ToolbarPiker(mySelect : Selector) -> UIToolbar {
        let toolBar = UIToolbar()

        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: mySelect)

        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        return toolBar
    }

}
