//
//  DetailGarageController.swift
//  CarParking
//
//  Created by Bonz on 8/22/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit

class DetailGarageController: UIViewController {
    
    var passData = GarageAdmin()
    
    @IBOutlet weak var lblAdmin: UITextField!
    @IBOutlet weak var lblGaraName: UITextField!
    @IBOutlet weak var lblAddress: UITextField!
    @IBOutlet weak var lblX: UITextField!
    @IBOutlet weak var lblY: UITextField!
    @IBOutlet weak var lblTotalSlot: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadViewDefault()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadViewDefault() {
        lblAdmin.text = passData.email
        lblGaraName.text = passData.name
        lblAddress.text = passData.address
        lblX.text = String(passData.locationX)
        lblY.text = String(passData.locationY)
        lblTotalSlot.text = String(passData.totalSlot)
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
