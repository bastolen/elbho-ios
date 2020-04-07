//
//  PDFViewController.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 21/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {
    var pdfLink: String = ""
    
    @IBOutlet var pdfView: PDFView!
    
    /**
     Shows the pdf on the current URL
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pdfDocument = PDFDocument(url: URL(string: pdfLink)!) {
            pdfView.displayMode = .singlePageContinuous
            pdfView.autoScales = true
            pdfView.displayDirection = .vertical
            pdfView.document = pdfDocument
        }
    }
}
