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
    case bodyInvalid
    case conflict
    case unauthorized
    case fileInvalid
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .api:
            return "error_api".localize
        case .bodyInvalid:
            return "error_body_invalid".localize
        case .conflict:
            return "error_conflict".localize
        case .unauthorized:
            return "error_unauthorized".localize
        case .fileInvalid:
            return "error_fileInvalid".localize
        }
    }
}
