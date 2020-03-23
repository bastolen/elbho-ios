//
//  String.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 11/11/2019.
//  Copyright © 2019 Bas Tolen. All rights reserved.
//

import Foundation

extension String {
    func localizeWithVars(_ arguments: CVarArg...) -> String{
        String(format: self.localize, arguments: arguments)
    }
    var localize: String{
        return NSLocalizedString(self, comment:"")
    }
}
