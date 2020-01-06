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

let months = ["Januari", "Februari", "Maart", "April", "Mei", "Juni", "Juli", "Augustus", "September", "Oktober", "November", "December"]
let daysOfMonth = ["Maandag", "Dinsdag", "Woensdag", "Donderdag", "Vrijdag", "Zaterdag", "Zondag"]
let daysShort = ["MA", "DI", "WO", "DO", "VR", "ZA", "ZO"]
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
