//
//  DateFormatter.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 19/11/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import Foundation

extension DateFormatter {
    /**
     Forrmatter used for formatting the JSON date to iOS date
     */
    static let apiDateResult: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
}
