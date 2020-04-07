//
//  DetailViewCell.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 05/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import UIKit

class DetailViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /**
     Reset the cell
     */
    override func prepareForReuse() {
        titleLabel.text = nil
        contentLabel.text = nil
        iconView.image = nil
        iconView.gestureRecognizers = []
        super.prepareForReuse()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
