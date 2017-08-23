//
//  CustomManagerCarCell.swift
//  CarParking
//
//  Created by Bonz on 8/15/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit

class CustomManagerCarCell: UITableViewCell {

    @IBOutlet weak var viewCar: UIView!
    @IBOutlet weak var imgCar: UIImageView!
    @IBOutlet weak var lblCarNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
