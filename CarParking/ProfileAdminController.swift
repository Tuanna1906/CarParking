//
//  ProfileAdminController.swift
//  CarParking
//
//  Created by Bonz on 8/23/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit

class ProfileAdminController: UIViewController {

    @IBOutlet weak var lblLastName: UITextField!
    @IBOutlet weak var lblFirstName: UITextField!
    @IBOutlet weak var lblEmail: UITextField!
    @IBOutlet weak var lblPhone: UITextField!
    @IBOutlet weak var lblBirthDay: UITextField!
    @IBOutlet weak var lblAddress: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LogoutTapped(_ sender: UIButton) {
        self.resetInstances()
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    func resetInstances() {
        Instances.sharedInstance.accountID = -1
        Instances.sharedInstance.role = 0
        Instances.sharedInstance.selectedGarageID = -1
        Instances.sharedInstance.garageID = -1
        UserDefaults.standard.set("", forKey: "tokenLogin")
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
