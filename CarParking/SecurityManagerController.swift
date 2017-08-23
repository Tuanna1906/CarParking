//
//  SecurityManagerController.swift
//  CarParking
//
//  Created by Bonz on 8/23/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit
import  SwiftyJSON

class SecurityManagerController: UIViewController,  UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var arrSecurity:[SecurityOfGarage] = []
    var securitySelected = SecurityOfGarage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadTableViewDefault()
        
        let navBar = self.navigationController?.navigationBar
        navBar?.isTranslucent = false
        
        let redPixel = UIImage(named: "background_navbar")
        navBar?.setBackgroundImage(redPixel, for: UIBarMetrics.default)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadTableViewDefault()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Action Button
    @IBAction func btnAddSecurityTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "gotoRegisterSecurityScreen", sender: self)
    }
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
    }
    
    //func
    
    func loadTableViewDefault() {
        
        SocketIOManager.sharedInstance.socket.emit(Constants.SECURITY.REQUEST_ALL_SECURITY, Instances.sharedInstance.garageID)
        SocketIOManager.sharedInstance.socket.on(Constants.SECURITY.RESPONSE_ALL_SECURITY, callback: { (data, ask) in
            
            let json = JSON(data)[0]
            self.arrSecurity = []
            print(json)
            if json["result"].boolValue == true{
                for item in json["data"].arrayValue {
                   let security = SecurityOfGarage.init(
                    id: item["id"].intValue,
                    firstName: item["firstName"].stringValue,
                    lastName: item["lastName"].stringValue,
                    phone: item["phone"].stringValue,
                    dateOfBirth: item["dateOfBirth"].stringValue,
                    email: item["email"].stringValue,
                    address: item["address"].stringValue,
                    roleID: item["roleID"].intValue)
                    self.arrSecurity.append(security)
                }
                self.tableView.reloadData()
            }
            
            self.tableView.reloadData()
            SocketIOManager.sharedInstance.socket.off(Constants.SECURITY.RESPONSE_ALL_SECURITY)
        })
        
    }

    
    // Mark: Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSecurity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "myCellSecurity", for: indexPath) as! CustomSecurityCell
            cell.lblEmail.text = self.arrSecurity[indexPath.row].email
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.securitySelected =  self.arrSecurity[indexPath.row]
        performSegue(withIdentifier: "gotoDetailSecurityScreen", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            
//            SocketIOManager.sharedInstance.socket.emit(Constants.Account.REQUEST_REMOVE_ACCOUNT_BY_ID, self.filteredDate[indexPath.row].accountID)
//            SocketIOManager.sharedInstance.socket.on(Constants.Account.RESPONSE_REMOVE_ACCOUNT_BY_ID, callback: { (data, ask) in
//                
//                let json = JSON(data)[0]
//                print(json)
//                if(json["result"].boolValue == true){
//                    var index:Int = -1
//                    
//                    for i in 0 ..< self.arrGarage.count {
//                        if self.arrGarage[i].id == self.filteredDate[indexPath.row].id{
//                            index = i
//                        }
//                    }
//                    self.arrGarage.remove(at: index)
//                    self.filteredDate.remove(at: indexPath.row)
//                    self.tableView.reloadData()
//                }
//                
//                SocketIOManager.sharedInstance.socket.off(Constants.Account.RESPONSE_REMOVE_ACCOUNT_BY_ID)
//            })
            
        }
    }
    


    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "gotoDetailSecurityScreen") {
            
            if let detailSecurityController = segue.destination as? DetailSecurityController {
                detailSecurityController.passData = self.securitySelected
            }
        }
    }

}
