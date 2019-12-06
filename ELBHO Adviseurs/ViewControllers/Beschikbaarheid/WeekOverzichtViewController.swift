//
//  WeekOverzichtViewController.swift
//  ELBHO Adviseurs
//
//  Created by Kevin Bosma on 05/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import UIKit

class WeekOverzichtViewController: UIViewController {

    var clickedDate = String()
    var weeknumberClickedDate = Int()
    var formattedDate = Date()
    
    let dateFormatter = DateFormatter()
    let calendar = Calendar.current
    
    // UI ELEMENTEN
    var datePicker = UIDatePicker()
    let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(dismissPicker))
    
    @IBOutlet weak var weekView: UIView!
    @IBOutlet weak var weekNumberLabel: UILabel!
    
    // Dag 1
    @IBOutlet weak var dateLabelDay1: UILabel!
    @IBOutlet weak var timeInputDay1From: UITextField!
    @IBOutlet weak var timeInputDay1Until: UITextField!
    
    // Dag 2
    @IBOutlet weak var dateLabelDay2: UILabel!
    @IBOutlet weak var timeInputDay2From: UITextField!
    @IBOutlet weak var timeInputDay2Until: UITextField!
    
    // Dag 3
    @IBOutlet weak var dateLabelDay3: UILabel!
    @IBOutlet weak var timeInputDay3From: UITextField!
    @IBOutlet weak var timeInputDay3Until: UITextField!
    
    
    // Dag 4
    @IBOutlet weak var dateLabelDay4: UILabel!
    @IBOutlet weak var timeInputDay4From: UITextField!
    @IBOutlet weak var timeInputDay4Until: UITextField!
    
    // Dag 5
    
    @IBOutlet weak var dateLabelDay5: UILabel!
    @IBOutlet weak var timeInputDay5From: UITextField!
    @IBOutlet weak var timeInputDay5Until: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Beschikbaarheid"
        
        formattedDate = formatStringToDate(toFormat: clickedDate)
        weekNumberLabel.text = "Week "+String(getWeekNumber(date: formattedDate))
        
        weekView.layer.borderWidth = 1
        weekView.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        
        datePicker.datePickerMode = .time
        datePicker.minuteInterval = 15
        
        setTimeInput()
        fillLabels()
    }
    
    func fillLabels()
    {
        let daysToShow = getDays()
        // Checken of er wel 5 dagen zijn doorgekomen
        if daysToShow.count == 5 {
            dateFormatter.dateFormat = "dd-MM-YY"
            dateLabelDay1.text = dateFormatter.string(from: daysToShow[0])
            dateLabelDay2.text = dateFormatter.string(from: daysToShow[1])
            dateLabelDay3.text = dateFormatter.string(from: daysToShow[2])
            dateLabelDay4.text = dateFormatter.string(from: daysToShow[3])
            dateLabelDay5.text = dateFormatter.string(from: daysToShow[4])
        }
    }
    
    func setTimeInput()
    {
        // datePicker zetten op Text fields
        timeInputDay1From.inputView = datePicker
        timeInputDay1From.inputAccessoryView = toolBar
        timeInputDay1Until.inputView = datePicker
        timeInputDay1Until.inputAccessoryView = toolBar
        
        timeInputDay2From.inputView = datePicker
        timeInputDay2From.inputAccessoryView = toolBar
        timeInputDay2Until.inputView = datePicker
        timeInputDay2Until.inputAccessoryView = toolBar
        
        timeInputDay3From.inputView = datePicker
        timeInputDay3From.inputAccessoryView = toolBar
        timeInputDay3Until.inputView = datePicker
        timeInputDay3Until.inputAccessoryView = toolBar
        
        timeInputDay4From.inputView = datePicker
        timeInputDay4From.inputAccessoryView = toolBar
        timeInputDay4Until.inputView = datePicker
        timeInputDay4Until.inputAccessoryView = toolBar
        
        timeInputDay5From.inputView = datePicker
        timeInputDay5From.inputAccessoryView = toolBar
        timeInputDay5Until.inputView = datePicker
        timeInputDay5Until.inputAccessoryView = toolBar
    }
    
    @objc func dismissPicker() {

        dateFormatter.dateFormat = "HH:mm"
        let pickedTime = dateFormatter.string(from: datePicker.date)
        
        if timeInputDay1From.isFirstResponder {
            timeInputDay1From.text = pickedTime
        } else if timeInputDay1Until.isFirstResponder {
            timeInputDay1Until.text = pickedTime
        } else if timeInputDay2From.isFirstResponder {
            timeInputDay2From.text = pickedTime
        } else if timeInputDay2Until.isFirstResponder {
            timeInputDay2Until.text = pickedTime
        } else if timeInputDay3From.isFirstResponder {
            timeInputDay3From.text = pickedTime
        } else if timeInputDay3Until.isFirstResponder {
            timeInputDay3Until.text = pickedTime
        } else if timeInputDay4From.isFirstResponder {
            timeInputDay4From.text = pickedTime
        } else if timeInputDay4Until.isFirstResponder {
            timeInputDay4Until.text = pickedTime
        } else if timeInputDay5From.isFirstResponder {
            timeInputDay5From.text = pickedTime
        } else if timeInputDay5Until.isFirstResponder {
            timeInputDay5Until.text = pickedTime
        }
        
        view.endEditing(true)

    }
    
    func getDays() -> [Date]
    {
        let today = formattedDate
        let dayOfWeek = calendar.component(.weekday, from: today)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }  // use `flatMap` in Xcode versions before 9.3
            .filter { !calendar.isDateInWeekend($0) }
        
        return days
    }
    
    func formatStringToDate(toFormat: String) -> Date {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Gegeven date format in String
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        let formatted = dateFormatter.date(from: toFormat)
        
        let finalDate = calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour], from: formatted!))! // Date maken van componenten
        
        return finalDate
    }
    
    // Oude zooi maar nog even bewaren
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
