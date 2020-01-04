//
//  Availability2.swift
//  ELBHO Adviseurs
//
//  Created by Kevin Bosma on 04/01/2020.
//  Copyright © 2020 Otters. All rights reserved.
//

import Foundation

struct Availability2: Codable {
    var date: String
    var start: String
    var end: String
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case start = "start"
        case end = "end"
    }
}
