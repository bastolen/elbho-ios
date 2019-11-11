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
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .api:
            return "error_api_message".localize
        }
    }
}
