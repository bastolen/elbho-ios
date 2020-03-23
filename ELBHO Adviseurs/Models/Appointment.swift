//
//  Appointment.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 05/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import Foundation

struct Appointment: Codable {
    let _id: String
    let StartTime: Date;
    let EndTime: Date;
    let Comment: String
    let Address: String
    let ContactPersonName: String
    let ContactPersonPhoneNumber: String
    let ContactPersonFunction: String
    let ContactPersonEmail: String
    let Active: Bool
    let Website: String
    let Logo: String
    let COCNumber: String
    let COCName: String
    let Advisor: String?
    let CreatedAt: Date
    let UpdatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case _id =  "_id"
        case StartTime = "startTime"
        case EndTime = "endTime"
        case Comment = "comment"
        case Address = "address"
        case ContactPersonName = "contactPersonName"
        case ContactPersonPhoneNumber = "contactPersonPhoneNumber"
        case ContactPersonFunction = "contactPersonFunction"
        case ContactPersonEmail = "contactPersonEmail"
        case Active = "active"
        case Website = "website"
        case Logo = "logo"
        case COCNumber = "cocNumber"
        case COCName = "cocName"
        case Advisor = "advisor"
        case CreatedAt = "createdAt"
        case UpdatedAt = "updatedAt"
    }
}
