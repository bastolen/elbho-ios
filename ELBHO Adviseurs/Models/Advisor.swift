//
//  Advisor.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 19/11/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import Foundation

struct Advisor: Codable {
    let _id: String
    let FirstName: String
    let LastName: String
    let Gender: String
    let PhoneNumber: String
    let Active: Bool
    let Status: String
    let Location: String
    let LastPinged: Date?
    let WorkArea: String
    let Region: String
    let PermissionLevel: Int
    let Email: String
    let CreatedAt: Date
    let UpdatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case FirstName = "firstName"
        case LastName = "lastName"
        case Gender = "gender"
        case PhoneNumber = "phoneNumber"
        case Active = "active"
        case Status = "status"
        case Location = "location"
        case WorkArea = "workArea"
        case Region = "region"
        case PermissionLevel = "permissionLevel"
        case Email = "email"
        case _id = "_id"
        case LastPinged = "lastPinged"
        case CreatedAt = "createdAt"
        case UpdatedAt = "updatedAt"
    }
}
