//
//  Car.swift
//  ELBHO Adviseurs
//
//  Created by Kevin Bosma on 05/01/2020.
//  Copyright © 2020 Otters. All rights reserved.
//

import Foundation

struct Car: Codable {
    var licensePlate: String
    var brand: String
    var model: String
    var location: String
    var image: URL
    var transmission : String
    
    enum CodingKeys: String, CodingKey {
        case licensePlate = "licensePlate"
        case brand = "brand"
        case model = "model"
        case location = "location"
        case image = "image"
        case transmission = "transmission"
    }
}
