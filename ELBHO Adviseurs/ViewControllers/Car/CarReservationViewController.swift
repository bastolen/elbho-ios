//
//  CarReservation.swift
//  ELBHO Adviseurs
//
//  Created by Kevin Bosma on 09/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import Foundation
import UIKit

class CarReservationViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var Calendar: UICollectionView!
    
    @IBOutlet weak var prevMonth: UIButton!
    @IBOutlet weak var nextMonth: UIButton!
    @IBOutlet weak var monthLabel: UILabel!
    
    var clickedDate = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Auto reserveren"
        
        Calendar.dataSource = self
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
