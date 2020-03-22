//
//  CarAvailability.swift
//  ELBHO Adviseurs
//
//  Created by Kevin Bosma on 09/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import Foundation

struct CarAvailability: Codable {
    var _id: String
    var licensePlate: String
    var brand: String
    var model: String
    var location: String
    var city: String
    var image: URL
    var transmission : String
    var reservations: [CarReservations]
    var selected : Bool = false
    
    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case licensePlate = "licensePlate"
        case brand = "brand"
        case model = "model"
        case location = "location"
        case city = "city"
        case image = "image"
        case transmission = "transmission"
        case reservations = "reservations"
    }
}


struct CarReservations: Codable {
    var vehicle: String?
    var date: Date
    var start: Date
    var end: Date
    
    enum CodingKeys: String, CodingKey {
        case vehicle = "vehicle"
        case date = "date"
        case start = "start"
        case end = "end"
    }
}
