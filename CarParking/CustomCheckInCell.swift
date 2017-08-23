//
//  CustomCheckInCell.swift
//  CarParking
//
//  Created by Bonz on 8/20/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit

protocol CustomCheckInCellDelegate {
    func didTapCheckIn(_ sender: UIButton)
}

class CustomCheckInCell: UITableViewCell {
    
    @IBOutlet weak var numberCar: UILabel!
    @IBOutlet weak var timeBooking: UILabel!
    @IBOutlet weak var btnCheckIn: UIButton!
    
    var delegate: CustomCheckInCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func checkInTapped(_ sender: UIButton) {
        delegate?.didTapCheckIn(sender)
    }

}
