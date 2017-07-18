//
//  LoginController.swift
//  CarParking
//
//  Created by Bonz on 7/14/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit
import SocketIO
import SwiftyJSON
import CryptoSwift
import SCLAlertView

class LoginController: UIViewController {
    
    //========== IBOutlet and var ============================================
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btn_checkbox: UIButton!
    
    
    //========== viewDidLoad====================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtPassword.isSecureTextEntry = true
        
        btn_checkbox.setImage(UIImage(named: "unchecked_checkbox"), for: .normal)
        btn_checkbox.setImage(UIImage(named: "checked_checkbox"), for: .selected)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //========== IBAction ====================================================
    @IBAction func clickBtnRemember(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        print(sender.isSelected)
        
    }
    
    @IBAction func clickBtnLogin(_ sender: UIButton) {
        sender.pulsate()
        let email = txtEmail.text!
        let password = txtPassword.text!
        let hash_password = password.sha512()
        
        
        if(email.isEmpty || password.isEmpty){
            self.showAlertWarning(title: "Null", subTitle: "Nhập Email, Mật khẩu", button: "Đóng")
        }else if password.characters.count < 6 {
            self.showAlertWarning(title: "", subTitle: "Mật khẩu phải hơn 6 kí tự", button: "Đóng")
        }else{
            
            SocketIOManager.sharedInstance.socket.emit(Constants.Account.REQUEST_LOGIN_WITH_EMAIL_AND_PASS, email, hash_password)
            SocketIOManager.sharedInstance.socket.on(Constants.Account.RESPONSE_LOGIN_WITH_EMAIL_AND_PASS, callback: {(data,ack) in
                let json = JSON(data)
                let passwordDB = json[0]["password"].bool!
                let emailDB = json[0]["email"].bool!
                if passwordDB == true && emailDB == true {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil);
                    let vc = storyboard.instantiateViewController(withIdentifier: "MapViewScreen") // MySecondSecreen the storyboard ID
                    self.present(vc, animated: true, completion: nil);
                }else{
                   
                }
                SocketIOManager.sharedInstance.socket.off(Constants.Account.RESPONSE_LOGIN_WITH_EMAIL_AND_PASS)
            })
            
        }
        
    }
    
    @IBAction func clickBtnRegister(_ sender: UIButton) {
        sender.pulsate()
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
