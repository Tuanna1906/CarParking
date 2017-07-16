//
//  LoginController.swift
//  CarParking
//
//  Created by Bonz on 7/14/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit
import SocketIO

class LoginController: UIViewController {

    @IBOutlet weak var btn_checkbox: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn_checkbox.setImage(UIImage(named: "unchecked_checkbox"), for: .normal)
        btn_checkbox.setImage(UIImage(named: "checked_checkbox"), for: .selected)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func clickBtnRemember(_ sender: UIButton) {
         sender.isSelected = !sender.isSelected
         print(sender.isSelected)
        
    }
    
    @IBAction func clickBtnLogin(_ sender: UIButton) {
        sender.pulsate()
    }

    @IBAction func clickBtnRegister(_ sender: UIButton) {
        sender.pulsate()
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
