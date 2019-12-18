//
//  Availability.swift
//  ELBHO Adviseurs
//
//  Created by Kevin Bosma on 18/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import Foundation

struct Availability: Codable {
    let _id: String
    let date: Date
    let start: Date
    let end: Date
    
    enum CodingKeys: String, CodingKey {
        case _id =  "_id"
        case date = "date"
        case start = "start"
        case end = "end"
    }
}
