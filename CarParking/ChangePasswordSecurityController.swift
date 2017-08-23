//
//  ChangePasswordSecurityController.swift
//  CarParking
//
//  Created by Bonz on 8/24/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit
import SwiftyJSON
import SCLAlertView

class ChangePasswordSecurityController: UIViewController {

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRePassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPassword.isSecureTextEntry = true
        txtRePassword.isSecureTextEntry = true
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ChangePassTapped(_ sender: UIButton) {
        
        let password = txtPassword.text!
        let rePassword = txtRePassword.text!
        
        
        if(password.isEmpty || rePassword.isEmpty){
            self.showAlertWarning(title: "Null", subTitle: "Nhập Mật khẩu, Xác nhận lại mật khẩu", button: "Đóng")
        }else if password.characters.count < 6 {
            self.showAlertWarning(title: "", subTitle: "Mật khẩu mới phải hơn 6 kí tự", button: "Đóng")
        }else if password != rePassword {
            self.showAlertWarning(title: "", subTitle: "Mật khẩu và Xác nhận lại mật khẩu không giống nhau", button: "Đóng")
        }else{
            let hash_password = password.sha512()
            
            SocketIOManager.sharedInstance.socket.emit(Constants.Account.REQUEST_CHANGE_PASSWORD, Instances.sharedInstance.email, hash_password)
            SocketIOManager.sharedInstance.socket.on(Constants.Account.RESPONSE_CHANGE_PASSWORD, callback: {(data,ack) in
                let json = JSON(data)
                let bool = json[0]["result"].bool!
                if bool == true {
                    self.showAlertSuccess(title: "Thành công", subTitle: "Thay đổi mật khẩu tài khoản thành công", button: "Đóng")
                }
                SocketIOManager.sharedInstance.socket.off(Constants.Account.RESPONSE_CHANGE_PASSWORD)
            })
            
        }
        
    }
    
    @IBAction func CancelTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //Func
    
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
