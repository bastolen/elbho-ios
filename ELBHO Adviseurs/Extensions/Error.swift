//
//  Error.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 11/11/2019.
//  Copyright © 2019 Bas Tolen. All rights reserved.
//

import Foundation

public enum CustomError: Error {
    case api
    case passwordMatch
    case conflict
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .api:
            return "error_api_message".localize
        case .passwordMatch:
            return "error_password_match_message".localize
        case .conflict:
            return "error_conflict_message".localize
        }
    }
}
