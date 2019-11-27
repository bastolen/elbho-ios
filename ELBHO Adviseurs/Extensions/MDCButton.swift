//
//  MDCButton.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 27/11/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import Foundation
import MaterialComponents.MDCButton

extension MDCButton {
    func makePrimary() -> Void {
        setBackgroundColor(UIColor(named: "Primary"), for: .normal)
        setBackgroundColor(UIColor(named: "Disabled"), for: .disabled)
        setBorderColor(.black, for: .disabled)
        setBorderWidth(2, for: .disabled)
        setTitleColor(.white, for: .normal)
        setTitleColor(.black, for: .disabled)
    }
}
