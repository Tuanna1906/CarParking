//
//  ManagerCarController.swift
//  CarParking
//
//  Created by Bonz on 8/15/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit
import SwiftyJSON
import SCLAlertView

class ManagerCarController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var carList: [Car] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavBar()
        self.loadTableViewDefault()
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //============= Function
    
    func loadTableViewDefault (){
        SocketIOManager.sharedInstance.socket.emit(Constants.Car.REQUEST_FIND_CAR_BY_ACCOUNT_ID, Instances.sharedInstance.accountID)
        SocketIOManager.sharedInstance.socket.on(Constants.Car.RESPONSE_FIND_CAR_BY_ACCOUNT_ID, callback: { (data, ask) in
            
            self.carList = []
            let json = JSON(data)[0]
            if json["result"] == true {
                for car in json["data"].arrayValue {
                    let xCar = Car.init(id: car["id"].intValue,
                                        accountID: car["accountID"].intValue,
                                        vehicleNumber: car["vehicleNumber"].stringValue)
                    self.carList.append(xCar)
                }
            }
            self.tableView.reloadData()
            
            
            SocketIOManager.sharedInstance.socket.off(Constants.Car.RESPONSE_FIND_CAR_BY_ACCOUNT_ID)
        })
        
    }
    
    func dropShadow(_ view: UIView) {
        
        //view.backgroundColor = UIColor(red: 228.0/255.0, green: 228.0/255.0, blue: 228.0/255.0, alpha: 0.5)
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 0
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.2
        
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        
    }
    
    
    func setupNavBar() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 64))
        //navBar.backgroundColor = UIColor.black
        let redPixel = UIImage(named: "background_navbar")
        navBar.setBackgroundImage(redPixel, for: UIBarMetrics.default)
        navBar.isTranslucent = false
        let navItem = UINavigationItem(title: "Danh sách xe")
        
        let image = UIImage(named: "ic_cancel")?.withRenderingMode(.alwaysOriginal)
        
        let cancelItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: #selector(clickBtnCancel))
        
        let imageRight = UIImage(named: "ic_add")?.withRenderingMode(.alwaysOriginal)
        
        let addItem = UIBarButtonItem(image: imageRight, style: .plain, target: nil, action: #selector(clickBtnAdd))
        
        navItem.leftBarButtonItem = cancelItem
        navItem.rightBarButtonItem = addItem
        navBar.setItems([navItem], animated: false)
        
        self.view.addSubview(navBar)
    }
    
    func clickBtnCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func clickBtnAdd() {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        let txtVehicleNumber = alert.addTextField("Nhập biển số xe")
        alert.addButton("Xác nhận") {
            let vehicleNumberNew = txtVehicleNumber.text
            SocketIOManager.sharedInstance.socket.emit(Constants.Car.REQUEST_ADD_NEW_CAR, Instances.sharedInstance.accountID, vehicleNumberNew!)
            SocketIOManager.sharedInstance.socket.on(Constants.Car.RESPONSE_ADD_NEW_CAR, callback: { (data, ask) in
                let json = JSON(data)[0]
                if(json["result"].boolValue == true){
                    self.loadTableViewDefault()
                }
                SocketIOManager.sharedInstance.socket.off(Constants.Car.RESPONSE_ADD_NEW_CAR)
            })
        }
        alert.addButton("Đóng"){}
        alert.showEdit("", subTitle: "Thêm biển số xe")
    }
    //============= MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.carList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "myCellManagerCar", for: indexPath) as! CustomManagerCarCell
        if(self.carList.count > 0){
            cell.lblCarNumber.text = self.carList[indexPath.row].vehicleNumber
            self.dropShadow(cell.viewCar)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            //                self.carList.remove(at: indexPath.row)
            //                self.tableView.reloadData()
            SocketIOManager.sharedInstance.socket.emit(Constants.Car.REQUEST_REMOVE_CAR_BY_ID, self.carList[indexPath.row].id)
            SocketIOManager.sharedInstance.socket.on(Constants.Car.RESPONSE_REMOVE_CAR_BY_ID, callback: { (data, ask) in
                let json = JSON(data)[0]
                if(json["result"].boolValue == true){
                    self.loadTableViewDefault()
                }
                SocketIOManager.sharedInstance.socket.off(Constants.Car.RESPONSE_REMOVE_CAR_BY_ID)
            })
            
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
