//
//  DateFormatter.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 19/11/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let apiNewsDateResult: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
}
