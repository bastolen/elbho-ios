//
//  CalendarVars.swift
//  ELBHO Adviseurs
//
//  Created by Kevin Bosma on 04/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import Foundation

let date = Date()
let calendar = Calendar.current

let months = [
    "month_1".localize,
    "month_2".localize,
    "month_3".localize,
    "month_4".localize,
    "month_5".localize,
    "month_6".localize,
    "month_7".localize,
    "month_8".localize,
    "month_9".localize,
    "month_10".localize,
    "month_11".localize,
    "month_12".localize
]
let daysOfMonth = ["day_1".localize, "day_2".localize, "day_3".localize, "day_4".localize, "day_5".localize, "day_6".localize, "day_7".localize]
let daysShort = [
     "day_1_small".localize,
     "day_2_small".localize,
     "day_3_small".localize,
     "day_4_small".localize,
     "day_5_small".localize,
     "day_6_small".localize,
     "day_7_small".localize
]
var daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

var currentMonth = String()
var numberOfEmptyBox = Int()
var nextNumberOfEmptyBox = Int()
var previousNumberOfEmtyBox = 0
var direction = 0 // 0 = HUIDIGE MAAND, 1 = MAAND VERDER, -1 = MAAND TERUG
var positionIndex = 0
var dayCounter = 0


let day = calendar.component(.day, from: date)
var weekday = calendar.component(.weekday, from: date) - 1
var month = calendar.component(.month, from: date) - 1
var year = calendar.component(.year, from: date)

func resetVars()
{
    currentMonth = String()
    numberOfEmptyBox = Int()
    nextNumberOfEmptyBox = Int()
    previousNumberOfEmtyBox = 0
    direction = 0
    positionIndex = 0
    dayCounter = 0
    
    weekday = calendar.component(.weekday, from: date) - 1
    month = calendar.component(.month, from: date) - 1
    year = calendar.component(.year, from: date)
    leapCheck()
    
}

func leapCheck()
{
    if (year % 4 == 0) {
        daysInMonth[1] = 29
    } else {
        daysInMonth[1] = 28
    }
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
        positionIndex = 0
    }
}
