//
//  ForgotPassController.swift
//  CarParking
//
//  Created by Bonz on 7/16/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit
import SCLAlertView
import SwiftyJSON

class ForgotPassController: UIViewController {

    //========== IBOutlet ==================================================
    @IBOutlet weak var txtEmail: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickBtnLayLaiMatKhau(_ sender: UIButton) {
        sender.pulsate()
        let email = txtEmail.text!
        if(email.isEmpty){
            self.showAlertWarning(title: "Null", subTitle: "Nhập Email", button: "Đóng")
        }else{
            
            SocketIOManager.sharedInstance.socket.emit(Constants.Account.REQUEST_RESET_PASSWORD, email)
            SocketIOManager.sharedInstance.socket.on(Constants.Account.RESPONSE_RESET_PASSWORD, callback: {(data,ack) in
                let json = JSON(data)
                let bool = json[0]["result"].bool!
                if bool == true {
                    self.showAlertSuccess(title: "", subTitle: "Một mã code lấy lại mật khẩu đã được gửi vào Email", button: "Đóng")
                }else{
                    self.showAlertWarning(title: "Không thành công", subTitle: "Email không tồn tại", button: "Đóng")
                }
                SocketIOManager.sharedInstance.socket.off(Constants.Account.RESPONSE_RESET_PASSWORD)
            })
            
        }

        
        
    }
    
    
    @IBAction func clickBtnCancel(_ sender: UIButton) {
        sender.pulsate()
        dismiss(animated: true, completion: nil)
    }
    
    
    //========== Function ==================================================
    
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
