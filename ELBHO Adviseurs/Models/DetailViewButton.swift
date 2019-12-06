//
//  DetailViewButton.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 05/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import Foundation

struct DetailViewButton {
    let text: String
    let style: colors
    let clicked: () -> Void
}

enum colors {
    case primary
    case secondary
    case danger
    case success
    case text
    case textPrimary
    case textSecondary
}
