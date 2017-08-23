//
//  RegisterAdminController.swift
//  CarParking
//
//  Created by Bonz on 8/22/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit
import SwiftyJSON
import SCLAlertView

class RegisterAdminController: UIViewController {

    
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
    
   

        
   
    @IBAction func btnRegisterAdminTapped(_ sender: UIButton) {
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
            
            SocketIOManager.sharedInstance.socket.emit(Constants.Account.REQUEST_CREATE_NEW_ACCOUNT, email, hash_password, 2)
            SocketIOManager.sharedInstance.socket.on(Constants.Account.RESPONSE_CREATE_NEW_ACCOUNT, callback: {(data,ack) in
                let json = JSON(data)
                let bool = json[0]["result"].bool!
                if bool == true {
                    self.showAlertSuccess(title: "Thành công", subTitle: "Đăng ký tài khoản thành công", button: "Đóng")
                }else{
                    self.showAlertWarning(title: "Không thành công", subTitle: "Email đã tồn tại", button: "Đóng")
                }
                SocketIOManager.sharedInstance.socket.off(Constants.Account.RESPONSE_CREATE_NEW_ACCOUNT)
            })
            
        }

        
    }

    //func
    
    func nextScreen(_ screen: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: screen) // MySecondSecreen the storyboard ID
        self.present(vc, animated: true, completion: nil)
    }
    
    func showAlertSuccess(title:String, subTitle:String, button:String) -> Void {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton(button) {
            let email = self.txtEmail.text!
            Instances.sharedInstance.newAdmin = email
            SocketIOManager.sharedInstance.socket.emit(Constants.Account.REQUEST_GET_ACCOUNT_ID_BY_EMAIL, email)
            SocketIOManager.sharedInstance.socket.on(Constants.Account.RESPONSE_GET_ACCOUNT_ID_BY_EMAIL, callback: { (data,ask) in
                let json = JSON(data)[0]
                    Instances.sharedInstance.newAdminId = json["id"].intValue
                    
                    self.nextScreen("RegisterGarageScreen")
                
               
                SocketIOManager.sharedInstance.socket.off(Constants.Account.RESPONSE_GET_ACCOUNT_ID_BY_EMAIL)
            })
            
            //dismiss(animated: true, completion: nil)
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

    
    // MARK: - Navigation


    

}
