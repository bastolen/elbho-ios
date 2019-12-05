//
//  BeschikbaarheidViewController.swift
//  ELBHO Adviseurs
//
//  Created by Kevin Bosma on 01/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import UIKit
import RxSwift
import SwiftKeychainWrapper
import MaterialComponents
import SideMenu

class BeschikbaarheidViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Calendar
    @IBOutlet weak var Calendar: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    let months = ["Januari", "Februari", "Maart", "April", "Mei", "Juni", "Juli", "Augustus", "September", "Oktober", "November", "December"]

    let daysOfMonth = ["Maandag", "Dinsdag", "Woensdag", "Donderdag", "Vrijdag", "Zaterdag", "Zondag"]
    let daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    var currentMonth = String()
    var numberOfEmptyBox = Int()
    var nextNumberOfEmptyBox = Int()
    var previousNumberOfEmtyBox = 0
    var direction = 0 // 0 = HUIDIGE MAAND, 1 = MAAND VERDER, -1 = MAAND TERUG
    var positionIndex = 0
    var dayCounter = 0
    var clickedDate = String()
    
    @IBOutlet weak var buttonPrev: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beschikbaarheid"
        
        // Start vullen calendar
        currentMonth = months[month]
        monthLabel.text = "\(currentMonth) \(year)"
        
        if weekday == 0 {
            weekday = 7
        }
        
        buttonNext.imageView?.tintColor = UIColor.black
        buttonPrev.imageView?.tintColor = UIColor.black
        
        getStartDateDayPosition()
        setupCollectionView()
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
    
    func getStartDateDayPosition()
    {
        switch direction {
        case 0:
            numberOfEmptyBox = weekday
            dayCounter = day
            while dayCounter > 0 {
                numberOfEmptyBox = numberOfEmptyBox - 1
                dayCounter = dayCounter - 1
                if numberOfEmptyBox == 0 {
                    numberOfEmptyBox = 7
                }
            }
            
            if numberOfEmptyBox == 7 {
                numberOfEmptyBox = 0
            }
            
            positionIndex = numberOfEmptyBox
        case 1...:
            nextNumberOfEmptyBox = (positionIndex + daysInMonth[month]) % 7
            positionIndex = nextNumberOfEmptyBox
        case -1:
            previousNumberOfEmtyBox = (7 - (daysInMonth[month] - positionIndex) % 7)
            if previousNumberOfEmtyBox == 7 {
                previousNumberOfEmtyBox = 0
            }
            positionIndex = previousNumberOfEmtyBox
        default:
            fatalError()
        }
    }
    
    @IBAction func prevMonth(_ sender: Any) {
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
    
    @IBAction func nextMonth(_ sender: Any) {
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
            return daysInMonth[month] + numberOfEmptyBox
        case 1:
            return daysInMonth[month] + nextNumberOfEmptyBox
        case -1:
            return daysInMonth[month] + previousNumberOfEmtyBox
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DateCollectionViewCell
        
        // Cell styling
        cell.backgroundColor = UIColor.clear
        cell.dateLabel.textColor = UIColor.black
        
        // Onzichtbare cellen zichtbaarmaken
        if cell.isHidden {
            cell.isHidden = false
        }
        
        // Maand directie bepalen 0 = HUIDIGE MAAND, 1 = MAAND VERDER, -1 = MAAND TERUG
        switch direction {
        case 0:
            cell.dateLabel.text = "\(indexPath.row + 1 - numberOfEmptyBox)"
        case 1:
            cell.dateLabel.text = "\(indexPath.row + 1 - nextNumberOfEmptyBox)"
        case -1:
            cell.dateLabel.text = "\(indexPath.row + 1 - previousNumberOfEmtyBox)"
        default:
            fatalError()
        }
        
        // Cell hiden wanner het 0 of negatief is
        if Int(cell.dateLabel.text!)! < 1 {
            cell.isHidden = true
        }
        
        // Kleurtje voor het weekend
        switch indexPath.row {
        case 5,6,12,13,19,20,26,27,33,34:
            if Int(cell.dateLabel.text!)! > 0 {
                cell.dateLabel.textColor = UIColor.lightGray
            }
        default:
            break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        clickedDate = "\(year)-\(month+1)-\(indexPath.row - positionIndex + 1)"
        print(clickedDate)
        let storyboard = UIStoryboard(name: "Beschikbaarheid", bundle: nil)
        let DetailVc = storyboard.instantiateViewController(withIdentifier: "WeekOverzichtViewController") as! WeekOverzichtViewController

        self.navigationController?.pushViewController(DetailVc, animated: true)
        
    }
}
