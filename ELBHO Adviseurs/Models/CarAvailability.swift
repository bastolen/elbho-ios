//
//  CarAvailability.swift
//  ELBHO Adviseurs
//
//  Created by Kevin Bosma on 09/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import Foundation

struct CarAvailability {
    let Id: String
    var car: String
    let availibleTime: Date
    let pickupAdres: String
    var selected : Bool = false
}
