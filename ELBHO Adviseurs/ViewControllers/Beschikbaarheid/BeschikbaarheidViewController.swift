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

class BeschikbaarheidViewController : UIViewController {
    let refreshControl = UIRefreshControl()
    let nc = NotificationCenter.default
    // Calendar
    @IBOutlet weak var Calendar: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var buttonPrev: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    
    var clickedDate = String()
    var checkDate = String()
    var monthCheck = Int()
    
    let dateFormatter = DateFormatter()
    let today = Date()
    
    private let disposeBag = DisposeBag()
    var items: [Availability?] = []
    private var callSend: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "title_availability".localize
        
        navigationController?.navigationBar.tintColor = .white
        initMenu(id: 3)
        resetVars()
        
        // Start vullen calendar
        currentMonth = months[month]
        monthLabel.text = "\(currentMonth) \(year)"
        
        if weekday == 0 {
            weekday = 7
        }
        
        Calendar.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(initContent), for: .allEvents)
        
        Calendar.layer.borderWidth = 1
        Calendar.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        
        nc.addObserver(self, selector: #selector(initContent), name: Notification.Name("reloadAvailibility"), object: nil)
        
        buttonNext.imageView?.tintColor = UIColor.black
        buttonPrev.imageView?.tintColor = UIColor.black
        
        getStartDateDayPosition()
        setupCollectionView()
        
        initContent()
    }
    
    @objc private func initContent() {
        print("Triggerd initContent")
        refreshControl.beginRefreshing()
        let before = NSCalendar.current.date(byAdding: .month, value: 2, to: today)!
        dateFormatter.dateFormat = "YYYY-MM-dd"
        if(!callSend) {
            items = []
            callSend = true
            APIService.getAvailability(after: dateFormatter.string(from: today), before: dateFormatter.string(from: before)).subscribe(onNext: { availability in
                self.items = availability
                self.Calendar.reloadData()
                self.callSend = false
                self.refreshControl.endRefreshing()
            }, onError: {error in
                self.showSnackbarDanger("error_api".localize)
                self.callSend = false
                self.refreshControl.endRefreshing()
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
        flow.itemSize = CGSize(width: cellWidth-6, height: 43)
    }
    
    
    @IBAction func prevMonth(_ sender: Any) {
        leapCheck()
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
    
    @IBAction func nextMonth(_ sender: Any) {
        leapCheck()
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

extension BeschikbaarheidViewController : UICollectionViewDelegate, UICollectionViewDataSource
{
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
                        checkDate = "\(year)-0\(month+1)-0\((indexPath.row-6) - positionIndex)"
                    } else {
                        checkDate = "\(year)-0\(month+1)-\((indexPath.row-6) - positionIndex)"
                    }

                    // Als checkDate in het verleden is rood maken
                    if dateFormatter.date(from: checkDate)!.isBefore(today) {
                        cell.backgroundColor = UIColor(named: "BorderColor")
                        cell.isUserInteractionEnabled = false
                        cell.dateLabel.textColor = UIColor.lightGray
                    } else {
                        for item in items {
                            if dateFormatter.string(from: item!.date) == checkDate {
                                print("BLAUW")
                                cell.backgroundColor = UIColor.init(named: "ActiveCellColor")!
                            }
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
        Vc.clickedDate = clickedDate+" 10:00:00"
        self.navigationController?.pushViewController(Vc, animated: true)
        
    }
}
