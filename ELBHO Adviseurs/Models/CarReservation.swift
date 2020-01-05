//
//  CarReservation.swift
//  ELBHO Adviseurs
//
//  Created by Kevin Bosma on 08/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import Foundation

struct CarReservation: Codable {
    var _id: String
    var vehicle: Car
    var date: Date
    var start: Date
    var end: Date
    
    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case vehicle = "vehicle"
        case date = "date"
        case start = "start"
        case end = "end"
    }
}
