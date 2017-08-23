//
//  ProfileController.swift
//  CarParking
//
//  Created by Bonz on 8/3/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit
import SwiftyJSON
import SCLAlertView

class ProfileController: UIViewController {
    
    @IBOutlet weak var lblLastName: UITextField!
    @IBOutlet weak var lblFirstName: UITextField!
    @IBOutlet weak var lblEmail: UITextField!
    @IBOutlet weak var lblPhone: UITextField!
    @IBOutlet weak var lblBirthDay: UITextField!
    @IBOutlet weak var lblAddress: UITextField!
    @IBOutlet weak var btnUpdate: CustomButton!
    
    var isEdit = false
    var userID = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
        self.loadViewDefault()
        self.editInfo(false)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
        
    }
    //Button
    
    @IBAction func UpdateInfoTapped(_ sender: UIButton) {
        sender.pulsate()
        let lastName =  self.lblLastName.text
        let firstName = self.lblFirstName.text
        let birthDay = self.lblBirthDay.text
        let address = self.lblAddress.text
        let phone = self.lblPhone.text
        
        SocketIOManager.sharedInstance.socket.emit(Constants.USER.REQUEST_EDIT_USER_BY_ID, self.userID, firstName!, lastName!, birthDay!, phone!, address!)
        SocketIOManager.sharedInstance.socket.on(Constants.USER.RESPONSE_EDIT_USER_BY_ID, callback: { (data, ask) in
            
            let json = JSON(data)[0]
            print(json)
            if json["result"].boolValue == true {
                self.showAlertSuccess(title:"", subTitle:"Cập nhật thông tin thành công", button:"Đóng")
                self.editInfo(false)
            }
            
            
            
            SocketIOManager.sharedInstance.socket.off(Constants.USER.RESPONSE_EDIT_USER_BY_ID)
        })

        
    }
    
    @IBAction func ChangePasswordTapped(_ sender: UIButton) {
        sender.pulsate()
    }
    
    @IBAction func clickBtnLogout(_ sender: UIButton) {
        sender.pulsate()
        SocketIOManager.sharedInstance.socket.emit(Constants.Account.REQUEST_LOG_OUT, Instances.sharedInstance.accountID)
        SocketIOManager.sharedInstance.socket.on(Constants.Account.RESPONSE_LOG_OUT, callback: { (data, ask) in
            
            let json = JSON(data)[0]
            if json["result"].boolValue == true {
                self.resetInstances()
                self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
            }
            
            
            
            SocketIOManager.sharedInstance.socket.off(Constants.Account.RESPONSE_LOG_OUT)
        })

        
        
    }
    func resetInstances() {
        Instances.sharedInstance.accountID = -1
        Instances.sharedInstance.role = 0
        Instances.sharedInstance.selectedGarageID = -1
        Instances.sharedInstance.garageID = -1
        UserDefaults.standard.set("", forKey: "tokenLogin")
    }
    //============= Function
    
    func loadViewDefault() {
        self.lblEmail.text = Instances.sharedInstance.email
        SocketIOManager.sharedInstance.socket.emit(Constants.USER.REQUEST_FIND_USER_BY_ACCOUNT_ID, Instances.sharedInstance.accountID)
        SocketIOManager.sharedInstance.socket.on(Constants.USER.RESPONSE_FIND_USER_BY_ACCOUNT_ID, callback: { (data, ask) in
            
            let json = JSON(data)[0]
            if json["result"].boolValue == true {
                self.userID = json["data"][0]["id"].intValue
                self.lblLastName.text = json["data"][0]["lastName"].stringValue
                self.lblFirstName.text = json["data"][0]["firstName"].stringValue
                self.lblAddress.text = json["data"][0]["address"].stringValue
                self.lblPhone.text = json["data"][0]["phone"].stringValue
                self.lblBirthDay.text = json["data"][0]["dateOfBirth"].stringValue
            }
            
            
            
            SocketIOManager.sharedInstance.socket.off(Constants.USER.RESPONSE_FIND_USER_BY_ACCOUNT_ID)
        })
    }
    
    func setupNavBar() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 64))
        //        navBar.backgroundColor = UIColor.black
        let redPixel = UIImage(named: "background_navbar")
        navBar.setBackgroundImage(redPixel, for: UIBarMetrics.default)
        navBar.isTranslucent = false
        let navItem = UINavigationItem(title: "Thông tin tài khoản")
        
        let image = UIImage(named: "ic_cancel")?.withRenderingMode(.alwaysOriginal)
        
        let cancelItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: #selector(clickBtnCancel))
        
        let editItem = UIBarButtonItem(title: "Sửa", style: .plain, target: nil, action: #selector(clickBtnEdit))
        
        navItem.leftBarButtonItem = cancelItem
        navItem.rightBarButtonItem = editItem
        navBar.setItems([navItem], animated: false)
        
        self.view.addSubview(navBar)
    }
    
    func clickBtnCancel() {
        self.dismiss(animated: true, completion: nil)
        print("cancel")
    }
    func clickBtnEdit() {
        if isEdit == false{
            self.editInfo(true)
        }else{
            self.editInfo(false)
        }
        isEdit = !isEdit
    }
    
    func editInfo(_ isEdit: Bool){
        if isEdit == false{
            self.btnUpdate.isHidden = true
            self.lblLastName.isUserInteractionEnabled = false
            self.lblFirstName.isUserInteractionEnabled = false
            self.lblBirthDay.isUserInteractionEnabled = false
            self.lblAddress.isUserInteractionEnabled = false
            self.lblPhone.isUserInteractionEnabled = false
            self.lblEmail.isUserInteractionEnabled = false
        }else{
            self.btnUpdate.isHidden = false
            self.lblLastName.isUserInteractionEnabled = true
            self.lblFirstName.isUserInteractionEnabled = true
            self.lblBirthDay.isUserInteractionEnabled = true
            self.lblAddress.isUserInteractionEnabled = true
            self.lblPhone.isUserInteractionEnabled = true
            self.lblEmail.isUserInteractionEnabled = false
        }
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
