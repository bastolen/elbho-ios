//
//  DetailView.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 05/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import Foundation
import UIKit

struct DetailViewRow {
    let title: String
    let content: String
    let icon: UIImage?
    let iconClicked: () -> Void
}
