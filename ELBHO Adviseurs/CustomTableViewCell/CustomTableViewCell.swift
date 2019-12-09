//
//  CustomTableViewCell.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 29/11/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var DayLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var CompanyLabel: UILabel!
    @IBOutlet weak var TimeLocationLabel: UILabel!
    
    @IBOutlet weak var imageViewBackground: UIImageView!
    @IBOutlet weak var rowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        DayLabel.text = nil
        DateLabel.text = nil
        CompanyLabel.text = nil
        TimeLocationLabel.text = nil
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
