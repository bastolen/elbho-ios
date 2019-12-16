//
//  ApiLoginModel.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 11/11/2019.
//  Copyright © 2019 Bas Tolen. All rights reserved.
//

import Foundation

struct ApiLogin: Codable {
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case token = "token"
    }
}
