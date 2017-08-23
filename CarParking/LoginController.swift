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
    
    var tokenLogin:String = ""
    var isCheckedCheckbox = false
    //========== viewDidLoad====================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkTokenLogin()
        
        //set
        txtPassword.isSecureTextEntry = true
        btn_checkbox.setImage(UIImage(named: "ic_unchecked_checkbox"), for: .normal)
        btn_checkbox.setImage(UIImage(named: "ic_checked_checkbox"), for: .selected)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //========== IBAction ====================================================
    @IBAction func clickBtnRemember(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isCheckedCheckbox = sender.isSelected
    }
    
    @IBAction func clickBtnLogin(_ sender: UIButton) {
        sender.pulsate()
        let email = txtEmail.text!
        let password = txtPassword.text!
        let hash_password = password.sha512()
        
        
        if(email.isEmpty || password.isEmpty){
            self.showAlertWarning(title: "Null", subTitle: "Nhập Email, Mật khẩu", button: "Đóng")
        }else if isValidEmail(testStr: email) == false{
            self.showAlertWarning(title: "", subTitle: "Định dạng Email sai", button: "Đóng")
        }else if password.characters.count < 6 {
            self.showAlertWarning(title: "", subTitle: "Mật khẩu phải hơn 6 kí tự", button: "Đóng")
        }else{
            SocketIOManager.sharedInstance.socket.emit(Constants.Account.REQUEST_LOGIN_WITH_EMAIL_AND_PASS, email, hash_password)
            SocketIOManager.sharedInstance.socket.on(Constants.Account.RESPONSE_LOGIN_WITH_EMAIL_AND_PASS, callback: {(data,ack) in
                let json = JSON(data)
                let passwordDB = json[0]["password"].bool!
                let emailDB = json[0]["email"].bool!
                var is_verifyBD = 1
                var txtToken = ""
                if json[0]["token"].exists() {
                    txtToken = json[0]["token"].string!
                }
                if(self.isCheckedCheckbox == true){
                    UserDefaults.standard.set(txtToken, forKey: "tokenLogin")
                    Instances.sharedInstance.email = email
                }
                
                if json[0]["is_verify"].exists() {
                    is_verifyBD = json[0]["is_verify"].int!
                }
                if is_verifyBD == 0{
                    let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: false
                    )
                    let alert = SCLAlertView(appearance: appearance)
                    let txtCode = alert.addTextField("Nhập mã code")
                    alert.addButton("Xác nhận") {
                        let code = txtCode.text!
                        //emit socket
                        SocketIOManager.sharedInstance.socket.emit(Constants.Account.REQUEST_COMPARE_CODE, email, code)
                        SocketIOManager.sharedInstance.socket.on(Constants.Account.RESPONSE_COMPARE_CODE, callback: { ( data, ask) in
                            let jsonx = JSON(data)
                            let resultDB = jsonx[0]["result"].bool!
                            //print(resultDB)
                            if resultDB == true{
                                self.setInstanceAccount(email: email)
                                
                            }else {
                                self.showAlertWarning(title: "", subTitle: "Mã code sai", button: "Đóng")
                            }
                            SocketIOManager.sharedInstance.socket.off(Constants.Account.RESPONSE_COMPARE_CODE)
                        })
                        
                    }
                    alert.addButton("Đóng"){}
                    alert.showEdit("", subTitle: "Tài khoản của bạn cần xác nhận, vui lòng kiểm tra Email lấy mã.")
                }else{
                    if passwordDB == true && emailDB == true {
                        self.setInstanceAccount(email: email)
                        
                    }else if passwordDB == false && emailDB == true{
                        self.showAlertWarning(title: "", subTitle: "Sai mật khẩu", button: "Đóng")
                    }else if passwordDB == false && emailDB == false{
                        self.showAlertWarning(title: "", subTitle: "Tài khoản không tồn tại", button: "Đóng")
                    }
                }
                
                
                SocketIOManager.sharedInstance.socket.off(Constants.Account.RESPONSE_LOGIN_WITH_EMAIL_AND_PASS)
            })
            
        }
        
    }
    
    @IBAction func clickBtnRegister(_ sender: UIButton) {
        sender.pulsate()
//        let storyboard = UIStoryboard(name: "Main", bundle: nil);
//        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterScreen") // MySecondSecreen the storyboard ID
//        vc.modalPresentationStyle = .popover
//        vc.modalTransitionStyle = .crossDissolve
//        
//        let popover = vc.popoverPresentationController!
//        popover.delegate = self as? UIPopoverPresentationControllerDelegate
//        
//        self.present(vc, animated: true, completion: nil);
    }
    
    //========== Function ==================================================
    
    func setInstanceAccount(email:String) {
        Instances.sharedInstance.email = email
        SocketIOManager.sharedInstance.socket.emit(Constants.Account.REQUEST_GET_ACCOUNT_ID_BY_EMAIL, email)
        SocketIOManager.sharedInstance.socket.on(Constants.Account.RESPONSE_GET_ACCOUNT_ID_BY_EMAIL, callback: { (data,ask) in
            let json = JSON(data)
            
            Instances.sharedInstance.accountID = json[0]["id"].intValue
            Instances.sharedInstance.role = json[0]["role"].intValue
            
            self.nextMapViewScreen(role: Instances.sharedInstance.role)
            SocketIOManager.sharedInstance.socket.off(Constants.Account.RESPONSE_GET_ACCOUNT_ID_BY_EMAIL)
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
    
    func checkTokenLogin(){
        if UserDefaults.standard.value(forKey: "tokenLogin") != nil && UserDefaults.standard.value(forKey: "tokenLogin") as! String != ""{
            tokenLogin = UserDefaults.standard.value(forKey: "tokenLogin") as! String
            
            //request server
            SocketIOManager.sharedInstance.socket.on("connect", callback: { (data, ask) in
                
                SocketIOManager.sharedInstance.socket.emit(Constants.Account.REQUEST_CHECK_TOKEN, self.tokenLogin)
                SocketIOManager.sharedInstance.socket.on(Constants.Account.RESPONSE_CHECK_TOKEN, callback: { (data, ask) in
                    let json = JSON(data)
                    //print(json)
                    if json[0]["id"].exists() && json[0]["role"].exists(){
                        Instances.sharedInstance.accountID = json[0]["id"].intValue
                        Instances.sharedInstance.role = json[0]["role"].intValue
                    }
                    let tokenDB = json[0]["result"].bool!
                    if tokenDB == true {
                        self.nextMapViewScreen(role: Instances.sharedInstance.role)
                    }
                    SocketIOManager.sharedInstance.socket.off(Constants.Account.RESPONSE_CHECK_TOKEN)
                })

            })
            
            
        }
        
    }
    
    func nextMapViewScreen(role: Int) {
        
        if role == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            let vc = storyboard.instantiateViewController(withIdentifier: "SuperAdminScreen") // MySecondSecreen the storyboard ID
            self.present(vc, animated: true, completion: nil);
        }else if role == 2{
            SocketIOManager.sharedInstance.socket.emit(Constants.Garage.REQUEST_GET_GARAGE_BY_ACCOUNT_ID, Instances.sharedInstance.accountID)
            SocketIOManager.sharedInstance.socket.on(Constants.Garage.RESPONSE_GET_GARAGE_BY_ACCOUNT_ID, callback: { (data,ask) in
                let json = JSON(data)[0]
                
                if json["result"].boolValue == true{
                    Instances.sharedInstance.garageID = json["data"][0]["id"].intValue
                }
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil);
                let vc = storyboard.instantiateViewController(withIdentifier: "AdminScreen") // MySecondSecreen the storyboard ID
                self.present(vc, animated: true, completion: nil);
                
                SocketIOManager.sharedInstance.socket.off(Constants.Garage.RESPONSE_GET_GARAGE_BY_ACCOUNT_ID)
            })
            
            
        }else if role == 3{
//            print(Instances.sharedInstance.accountID)
//            print(Instances.sharedInstance.role)
//            print(Instances.sharedInstance.selectedGarageID)
            SocketIOManager.sharedInstance.socket.emit(Constants.SECURITY.REQUEST_FIND_SECURITY_BY_ACCOUNT_ID, Instances.sharedInstance.accountID)
            SocketIOManager.sharedInstance.socket.on(Constants.SECURITY.RESPONSE_FIND_SECURITY_BY_ACCOUNT_ID, callback: { (data,ask) in
                let json = JSON(data)[0]
                if json["result"].boolValue == true{
                    Instances.sharedInstance.garageID = json["data"][0]["garageID"].intValue
                }
                //print(Instances.sharedInstance.garageID)
                let storyboard = UIStoryboard(name: "Main", bundle: nil);
                let vc = storyboard.instantiateViewController(withIdentifier: "SecurityScreen") // MySecondSecreen the storyboard ID
                self.present(vc, animated: true, completion: nil);

                SocketIOManager.sharedInstance.socket.off(Constants.SECURITY.RESPONSE_FIND_SECURITY_BY_ACCOUNT_ID)
            })

                    }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            let vc = storyboard.instantiateViewController(withIdentifier: "MapViewScreen") // MySecondSecreen the storyboard ID
            self.present(vc, animated: true, completion: nil);
        }
       
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
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
