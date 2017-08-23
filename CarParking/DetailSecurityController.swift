//
//  DetailSecurityController.swift
//  CarParking
//
//  Created by Bonz on 8/23/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit

class DetailSecurityController: UIViewController {
    
    @IBOutlet weak var lblLastName: UITextField!
    @IBOutlet weak var lblFirstName: UITextField!
    @IBOutlet weak var lblEmail: UITextField!
    @IBOutlet weak var lblPhone: UITextField!
    @IBOutlet weak var lblBirthDay: UITextField!
    @IBOutlet weak var lblAddress: UITextField!
    
    
    var passData = SecurityOfGarage()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadViewDefault()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadViewDefault() {
        self.lblLastName.text = passData.lastName
        self.lblFirstName.text = passData.firstName
        self.lblEmail.text = passData.email
        self.lblPhone.text = passData.phone
        self.lblBirthDay.text = passData.dateOfBirth
        self.lblAddress.text = passData.address
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
