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
    
    @IBOutlet weak var dateLabelDay1: UILabel!
    @IBOutlet weak var timeInputDay1From: UITextField!
    @IBOutlet weak var timeInputDay1Until: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Beschikbaarheid"
        
        formattedDate = formatStringToDate(toFormat: clickedDate)
        weekNumberLabel.text = "Week "+String(getWeekNumber(date: formattedDate))
        
        weekView.layer.borderWidth = 1
        weekView.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        
        datePicker.datePickerMode = .time
        
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
        }
    }
    
    func setTimeInput()
    {
        // datePicker zetten op Text fields
        timeInputDay1From.inputView = datePicker
        timeInputDay1From.inputAccessoryView = toolBar
        
        timeInputDay1Until.inputView = datePicker
        timeInputDay1Until.inputAccessoryView = toolBar
        
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
    
    @objc func dismissPicker() {

        dateFormatter.dateFormat = "HH:mm"
        let pickedTime = dateFormatter.string(from: datePicker.date)
        
        if timeInputDay1From.isFirstResponder {
            timeInputDay1From.text = pickedTime
        }
        
        view.endEditing(true)

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
