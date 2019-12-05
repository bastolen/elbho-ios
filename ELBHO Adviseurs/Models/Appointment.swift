//
//  Appointment.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 05/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import Foundation

struct Appointment: Codable {
    let Id: String
    let AppointmentDatetime: Date;
    let Comment: String
    let Address: String
    let PhoneNumber: String
    let ContactPersonName: String
    let ContactPersonPhoneNumber: String
    let ContactPersonFunction: String
    let Active: Bool
    let Website: String
    let Logo: String
    let COCNumber: String
    let COCName: String
    let FirstChoice: String
    let SecondChoice: String
    let ThirdChoice: String
    let CreatedDate: Date
    let ModifiedDate: Date
    
    enum CodingKeys: String, CodingKey {
        case Id =  "id"
        case AppointmentDatetime = "appointmentDatetime"
        case Comment = "comment"
        case Address = "address"
        case PhoneNumber = "phoneNumber"
        case ContactPersonName = "contactPersonName"
        case ContactPersonPhoneNumber = "contactPersonPhoneNumber"
        case ContactPersonFunction = "contactPersonFunction"
        case Active = "active"
        case Website = "website"
        case Logo = "logo"
        case COCNumber = "cocNumber"
        case COCName = "cocName"
        case FirstChoice = "firstChoice"
        case SecondChoice = "secondChoice"
        case ThirdChoice = "thirdChoice"
        case CreatedDate = "createdDate"
        case ModifiedDate = "modifiedDate"
    }
}
