//
//  CustomHistoryCell.swift
//  CarParking
//
//  Created by Bonz on 8/3/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit

class CustomHistoryCell: UITableViewCell {

    @IBOutlet weak var viewInfoHistory: UIView!
    @IBOutlet weak var lblHistory: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
