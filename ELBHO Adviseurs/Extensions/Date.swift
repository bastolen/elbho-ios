//
//  Date.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 16/02/2020.
//  Copyright © 2020 Otters. All rights reserved.
//

import Foundation

extension Date {
    func isBefore(_ otherDate: Date) -> Bool {
        return Int(self.distance(to: otherDate)) > 0
    }
}
