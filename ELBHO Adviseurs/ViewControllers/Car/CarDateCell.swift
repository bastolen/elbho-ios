//
//  CarDateCell.swift
//  ELBHO Adviseurs
//
//  Created by Kevin Bosma on 09/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import Foundation
import UIKit

class CarDateCell : UICollectionViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = true
        self.isHidden = false
    }
}
