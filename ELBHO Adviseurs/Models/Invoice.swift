//
//  Invoice.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 06/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import Foundation

struct Invoice: Codable {
    let Id: String
    let AdvisorId: String
    let UploadDate: Date
    let FileName: String
    let FilePath: String
    let Base64EncodedPdf: String
    
    enum CodingKeys: String, CodingKey {
        case Id = "id"
        case AdvisorId = "advisorId"
        case UploadDate = "uploadDate"
        case FileName = "fileName"
        case FilePath = "filePath"
        case Base64EncodedPdf = "base64EncodedPdf"
    }
}
