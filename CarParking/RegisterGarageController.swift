//
//  RegisterGarageController.swift
//  CarParking
//
//  Created by Bonz on 8/22/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit
import SwiftyJSON
import SCLAlertView

class RegisterGarageController: UIViewController {
    
    @IBOutlet weak var lblAdmin: UITextField!
    @IBOutlet weak var lblGaraName: UITextField!
    @IBOutlet weak var lblAddress: UITextField!
    @IBOutlet weak var lblX: UITextField!
    @IBOutlet weak var lblY: UITextField!
    @IBOutlet weak var lblTotalSlot: UITextField!
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblAdmin.text = Instances.sharedInstance.newAdmin
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnRegisterGarageTapped(_ sender: UIButton) {
        let garaName = lblGaraName.text!
        let address = lblAddress.text!
        let x = Double(lblX.text!)
        let y = Double(lblY.text!)
        let totalSlot = Int(lblTotalSlot.text!)
        
        
        if(garaName.isEmpty || address.isEmpty || lblX.text!.isEmpty || lblY.text!.isEmpty || lblTotalSlot.text!.isEmpty){
            self.showAlertWarning(title: "Null", subTitle: "Thông tin không được trống", button: "Đóng")
        }else{
            SocketIOManager.sharedInstance.socket.emit(Constants.Garage.REQUEST_ADD_NEW_GARAGE,
                    garaName, address,totalSlot!, 0, x!, y!, Instances.sharedInstance.newAdminId, 0,0,0)
            SocketIOManager.sharedInstance.socket.on(Constants.Garage.RESPONSE_ADD_NEW_GARAGE, callback: { (data,ask) in
                let json = JSON(data)[0]
                if(json["result"].boolValue == true){
                     self.showAlertSuccess(title: "Thành công", subTitle: "Đăng ký Garage thành công", button: "Đóng")
                }
                
                SocketIOManager.sharedInstance.socket.off(Constants.Garage.RESPONSE_ADD_NEW_GARAGE)
            })
        }
    }
    
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        sender.pulsate()
        SocketIOManager.sharedInstance.socket.emit(Constants.Account.REQUEST_REMOVE_ACCOUNT_BY_ID, Instances.sharedInstance.newAdminId)
        SocketIOManager.sharedInstance.socket.on(Constants.Account.RESPONSE_REMOVE_ACCOUNT_BY_ID, callback: { (data,ask) in
            let json = JSON(data)[0]
            if(json["result"].boolValue == true){
                self.dismiss(animated: true, completion: nil)
            }
            
            SocketIOManager.sharedInstance.socket.off(Constants.Account.RESPONSE_REMOVE_ACCOUNT_BY_ID)
        })
        
        
    }
    
    func showAlertSuccess(title:String, subTitle:String, button:String) -> Void {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton(button) {
            
            self.dismiss(animated: true, completion: nil)
        }
        alertView.showSuccess(title, subTitle: subTitle)
    }
    
    func showAlertWarning(title:String, subTitle:String, button:String) -> Void {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton(button) {}
        alertView.showWarning(title, subTitle: subTitle)
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
