//
//  NSAttributedString.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 22/03/2020.
//  Copyright © 2020 Otters. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    /**
     Makes a part of the string bold
     */
    static func getPartBold(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }

}
