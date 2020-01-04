//
//  Availability.swift
//  ELBHO Adviseurs
//
//  Created by Kevin Bosma on 18/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import Foundation

struct Availability: Codable {
    var date: Date
    var start: Date
    var end: Date
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case start = "start"
        case end = "end"
    }
}
