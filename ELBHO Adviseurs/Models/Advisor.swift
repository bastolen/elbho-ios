//
//  Advisor.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 19/11/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import Foundation

struct Advisor: Codable {
    let Id: String
    let FirstName: String
    let LastName: String
    let Gender: String
    let PhoneNumber: String
    let Active: Bool
    let Status: String
    let Location: String
    let WorkArea: String
    let Region: String
    let PermissionLevel: Int
    let Email: String
    let CreatedDate: String
    let ModifiedDate: String
    
    enum CodingKeys: String, CodingKey {
        case FirstName = "firstname"
        case LastName = "lastname"
        case Gender = "gender"
        case PhoneNumber = "phoneNumber"
        case Active = "active"
        case Status = "status"
        case Location = "location"
        case WorkArea = "workArea"
        case Region = "region"
        case PermissionLevel = "permissionLevel"
        case Email = "email"
        case Id = "id"
        case CreatedDate = "createdDate"
        case ModifiedDate = "modifiedDate"
    }
}
