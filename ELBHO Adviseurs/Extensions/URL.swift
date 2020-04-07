//
//  URL.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 21/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import Foundation
import MobileCoreServices

extension URL {
    /**
     Returns the mimeType of the file of the URL
     */
    func mimeType() -> String {
        let pathExtension = self.pathExtension
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
}
