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
    
    @IBOutlet weak var buttonPrev: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    
    var clickedDate = String()
    var checkDate = String()
    
    let dateFormatter = DateFormatter()
    
    private let disposeBag = DisposeBag()
    var items: [Availability?] = []
    private var callSend: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beschikbaarheid"
        navigationController?.navigationBar.tintColor = .white
        resetVars()
        
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
        
        initContent()
    }
    
    private func initContent() {
        if(!callSend) {
            items = []
            callSend = true
            APIService.getAvailability(after: "2019-11-01T00:00:00.000Z", before: "2019-12-31T00:00:00.000Z").subscribe(onNext: { availability in
                self.items = availability
                self.Calendar.reloadData()
                self.callSend = false
            }, onError: {error in
                self.showSnackbarDanger("error_api".localize)
                self.callSend = false
            }).disposed(by: disposeBag)
        }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DateCollectionViewCell
        
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
                if items.count > 0 {
                    dateFormatter.dateFormat = "YYYY-MM-dd"
                    // Checken op beschikbaarheid
                    if((indexPath.row-6) - positionIndex) < 10 {
                        checkDate = "\(year)-\(month+1)-0\((indexPath.row-6) - positionIndex)"
                    } else {
                        checkDate = "\(year)-\(month+1)-\((indexPath.row-6) - positionIndex)"
                    }
                    
                    for item in items {
                        if dateFormatter.string(from: item!.date) == checkDate {
                            cell.backgroundColor = UIColor.init(named: "ActiveCellColor")!
                        }
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
        
        let storyboard = UIStoryboard(name: "Beschikbaarheid", bundle: nil)
        let Vc = storyboard.instantiateViewController(withIdentifier: "WeekOverzichtViewController") as! WeekOverzichtViewController
        Vc.clickedDate = clickedDate+" 12:00:00"
        self.navigationController?.pushViewController(Vc, animated: true)
        
    }
}
