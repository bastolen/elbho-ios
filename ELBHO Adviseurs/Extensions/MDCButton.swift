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
    func setPrimary() -> Void {
        setBackgroundColor(UIColor(named: "Primary"), for: .normal)
        setBackgroundColor(UIColor(named: "Disabled"), for: .disabled)
        setBorderColor(.black, for: .disabled)
        setBorderWidth(2, for: .disabled)
        setTitleColor(.white, for: .normal)
        setTitleColor(.black, for: .disabled)
    }
    
    func setSecondary() -> Void {
        setBackgroundColor(UIColor(named: "Secondary"), for: .normal)
        setBackgroundColor(UIColor(named: "Disabled"), for: .disabled)
        setBorderColor(.black, for: .disabled)
        setBorderWidth(2, for: .disabled)
        setTitleColor(.white, for: .normal)
        setTitleColor(.black, for: .disabled)
    }
    
    func setSuccess() -> Void {
        setBackgroundColor(UIColor(named: "Success"), for: .normal)
        setBackgroundColor(UIColor(named: "Disabled"), for: .disabled)
        setBorderColor(.black, for: .disabled)
        setBorderWidth(2, for: .disabled)
        setTitleColor(.white, for: .normal)
        setTitleColor(.black, for: .disabled)
    }
    
    func setDanger() -> Void {
        setBackgroundColor(UIColor(named: "Danger"), for: .normal)
        setBackgroundColor(UIColor(named: "Disabled"), for: .disabled)
        setBorderColor(.black, for: .disabled)
        setBorderWidth(2, for: .disabled)
        setTitleColor(.white, for: .normal)
        setTitleColor(.black, for: .disabled)
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
