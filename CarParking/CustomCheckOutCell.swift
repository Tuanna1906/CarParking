//
//  CustomCheckOutCell.swift
//  CarParking
//
//  Created by Bonz on 8/21/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit

protocol CustomCheckOutCellDelegate {
    func didTapCheckOut(_ sender: UIButton)
}


class CustomCheckOutCell: UITableViewCell {

    @IBOutlet weak var carNumber: UILabel!
    @IBOutlet weak var timeBooking: UILabel!
    @IBOutlet weak var timeGoIn: UILabel!
    @IBOutlet weak var btnCheckOut: UIButton!
    
    var delegate: CustomCheckOutCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func checkOutTapped(_ sender: UIButton) {
        delegate?.didTapCheckOut(sender)
    }
}
