//
//  DateCollectionViewCell.swift
//  ELBHO Adviseurs
//
//  Created by Kevin Bosma on 04/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import UIKit

class DateCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        self.backgroundColor = UIColor.clear
        dateLabel.textColor = UIColor.black
        self.isUserInteractionEnabled = true
        self.isHidden = false
    }
}
