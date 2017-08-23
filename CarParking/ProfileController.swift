//
//  ProfileController.swift
//  CarParking
//
//  Created by Bonz on 8/3/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProfileController: UIViewController {
    
    @IBOutlet weak var lblLastName: UITextField!
    @IBOutlet weak var lblFirstName: UITextField!
    @IBOutlet weak var lblEmail: UITextField!
    @IBOutlet weak var lblPhone: UITextField!
    @IBOutlet weak var lblBirthDay: UITextField!
    @IBOutlet weak var lblAddress: UITextField!
    @IBOutlet weak var btnUpdate: CustomButton!
    
    var isEdit = false
    
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
    }
    
    @IBAction func ChangePasswordTapped(_ sender: UIButton) {
        sender.pulsate()
    }
    
    @IBAction func clickBtnLogout(_ sender: UIButton) {
        sender.pulsate()
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
    //============= Function
    
    func loadViewDefault() {
        self.lblEmail.text = Instances.sharedInstance.email
        SocketIOManager.sharedInstance.socket.emit(Constants.USER.REQUEST_FIND_USER_BY_ACCOUNT_ID, Instances.sharedInstance.accountID)
        SocketIOManager.sharedInstance.socket.on(Constants.USER.RESPONSE_FIND_USER_BY_ACCOUNT_ID, callback: { (data, ask) in
            
            let json = JSON(data)[0]
            if json["result"].boolValue == true {
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
