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
    private func setButton(_ type: String) {
        setBackgroundColor(UIColor(named: type), for: .normal)
        setBackgroundColor(UIColor(named: "Disabled"), for: .disabled)
        setBorderColor(.black, for: .disabled)
        setBorderWidth(2, for: .disabled)
        setTitleColor(.white, for: .normal)
        setTitleColor(.black, for: .disabled)
        
        if self.currentImage != nil {
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        }
    }
    
    func setPrimary() -> Void {
        setButton("Primary")
    }
    
    func setSecondary() -> Void {
        setButton("Secondary")
    }
    
    func setSuccess() -> Void {
        setButton("Success")
    }
    
    func setDanger() -> Void {
        setButton("Danger")
    }
    
    func setTextPrimary() -> Void {
        let colorScheme = MDCContainerScheme()
        colorScheme.colorScheme = getColorScheme(true)
        applyTextTheme(withScheme: colorScheme)
    }
    
    func setTextSecondary() -> Void {
        let colorScheme = MDCContainerScheme()
        colorScheme.colorScheme = getColorScheme(false)
        applyTextTheme(withScheme: colorScheme)
        
    }
    
    private func getColorScheme(_ isPrimary: Bool) -> MDCSemanticColorScheme {
        let colorScheme = MDCSemanticColorScheme()
        if isPrimary {
            colorScheme.primaryColor = UIColor(named: "Primary")!
        } else {
            colorScheme.primaryColor = UIColor(named: "Secondary")!
        }
        return colorScheme
    }
}
