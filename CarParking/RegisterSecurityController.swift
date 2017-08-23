//
//  RegisterSecurityController.swift
//  CarParking
//
//  Created by Bonz on 8/23/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit
import SwiftyJSON
import SCLAlertView

class RegisterSecurityController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
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
    
    //Action Button
    
    @IBAction func clickBtnRegister(_ sender: UIButton) {
        sender.pulsate()
        let email = txtEmail.text!
        let password = txtPassword.text!
        let rePassword = txtRePassword.text!
        
        
        if(email.isEmpty || password.isEmpty || rePassword.isEmpty){
            self.showAlertWarning(title: "Null", subTitle: "Nhập Email, Mật khẩu, Xác nhận lại mật khẩu", button: "Đóng")
        }else if password.characters.count < 6 {
            self.showAlertWarning(title: "", subTitle: "Mật khẩu phải hơn 6 kí tự", button: "Đóng")
        }else if password != rePassword {
            self.showAlertWarning(title: "", subTitle: "Mật khẩu và Xác nhận lại mật khẩu không giống nhau", button: "Đóng")
        }else{
            let hash_password = password.sha512()
            
            SocketIOManager.sharedInstance.socket.emit(Constants.Account.REQUEST_CREATE_ACCOUNT_SECURITY, email, hash_password, Instances.sharedInstance.accountID)
            SocketIOManager.sharedInstance.socket.on(Constants.Account.RESPONSE_CREATE_ACCOUNT_SECURITY, callback: {(data,ack) in
                let json = JSON(data)
                let bool = json[0]["result"].bool!
                if bool == true {
                    self.showAlertSuccess(title: "Thành công", subTitle: "Đăng ký tài khoản thành công", button: "Đóng")
                }else{
                    self.showAlertWarning(title: "Không thành công", subTitle: "Email đã tồn tại", button: "Đóng")
                }
                SocketIOManager.sharedInstance.socket.off(Constants.Account.RESPONSE_CREATE_ACCOUNT_SECURITY)
            })
            
        }
        
    }

    

    
    // Func
    func showAlertSuccess(title:String, subTitle:String, button:String) -> Void {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton(button) {
            
            self.performSegue(withIdentifier: "backSecurityManagerScreen", sender: self)
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
