//
//  CustomGarageCell.swift
//  CarParking
//
//  Created by Bonz on 8/22/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit

class CustomGarageCell: UITableViewCell {

    @IBOutlet weak var garageName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var admin: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
