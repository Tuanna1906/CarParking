//
//  CustomNearestPlaceTableViewCell.swift
//  CarParking
//
//  Created by Bonz on 8/3/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit

class CustomNearestPlaceCell: UITableViewCell {

    @IBOutlet weak var lblNameGarage: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var viewInfoPlace: UIView!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblEmptySlot: UILabel!
    @IBOutlet weak var lblTotalSlot: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
