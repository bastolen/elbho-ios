//
//  Invoice.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 06/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import Foundation

struct Invoice: Codable {
    let _id: String
    let Advisor: String
    let InvoiceMonth: Date
    let FileName: String
    let FilePath: String
    let Date: Date
    let CreatedAt: Date
    let UpdatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case Advisor = "advisor"
        case InvoiceMonth = "invoiceMonth"
        case FileName = "fileName"
        case FilePath = "filePath"
        case Date = "date"
        case CreatedAt = "createdAt"
        case UpdatedAt = "updatedAt"
    }
}
