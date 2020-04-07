//
//  String.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 11/11/2019.
//  Copyright © 2019 Bas Tolen. All rights reserved.
//

import Foundation

/**
 Translation functions for using the strings file. Usable with vars if there is a %@ in the localized string
 */
extension String {
    func localizeWithVars(_ arguments: CVarArg...) -> String{
        String(format: self.localize, arguments: arguments)
    }
    var localize: String{
        return NSLocalizedString(self, comment:"")
    }
}
