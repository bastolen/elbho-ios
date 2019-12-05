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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var t = getWeekByClickedDate(toFormat: clickedDate)
        print(t)
    }
    
    func getWeekByClickedDate(toFormat: String) -> Int {
        let calendar = Calendar.current
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Gegeven date format in String
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        let formatted = dateFormatter.date(from: toFormat)
        
        let finalDate = calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour], from: formatted!)) // Date maken van componenten
        
        let weekOfYear = calendar.component(.weekOfYear, from: finalDate!)
        
        return weekOfYear
    }


}
