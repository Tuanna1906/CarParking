//
//  HistoryController.swift
//  CarParking
//
//  Created by Bonz on 8/3/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit
import SwiftyJSON

class HistoryController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrHistory: [HistoryParkingInfo] = []
    var arrCars: [Car] = []
    var arrGarages: [Garage] = []
    
    
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
    func loadTableViewDefault() {
        
        //Load Car
        SocketIOManager.sharedInstance.socket.emit(Constants.Car.REQUEST_FIND_CAR_BY_ACCOUNT_ID, Instances.sharedInstance.accountID)
        SocketIOManager.sharedInstance.socket.on(Constants.Car.RESPONSE_FIND_CAR_BY_ACCOUNT_ID, callback: { (data, ask) in
            
            self.arrCars = []
            let json = JSON(data)[0]
            if json["result"] == true {
                for car in json["data"].arrayValue {
                    let xCar = Car.init(id: car["id"].intValue,
                                        accountID: car["accountID"].intValue,
                                        vehicleNumber: car["vehicleNumber"].stringValue)
                    self.arrCars.append(xCar)
                }
            }
            
            
            //Load All Garage
            SocketIOManager.sharedInstance.socket.emit(Constants.Garage.REQUEST_GET_ALL_GARAGES)
            SocketIOManager.sharedInstance.socket.on(Constants.Garage.RESPONSE_GET_ALL_GARAGE, callback: { (data, ask) in
                
                let json = JSON(data)[0]["Garages"]
                self.arrGarages = []
                for item in json.arrayValue {
                    let garage = Garage.init(id: item["id"].intValue,
                                             name: item["name"].stringValue,
                                             address: item["address"].stringValue,
                                             totalSlot: item["totalSlot"].intValue,
                                             busySlot: item["busySlot"].intValue,
                                             locationX: item["locationX"].doubleValue,
                                             locationY: item["locationY"].doubleValue,
                                             accountID: item["accountID"].intValue,
                                             timeStart: item["timeStart"].stringValue,
                                             timeEnd: item["timeEnd"].stringValue,
                                             xStatus: item["xStatus"].intValue)
                    self.arrGarages.append(garage)
                }
                
                //Load History
                
                
                SocketIOManager.sharedInstance.socket.emit(Constants.PARKING_INFO.REQUEST_PARKING_INFO_HISTORY_BY_ACCOUNT_ID, Instances.sharedInstance.accountID)
                SocketIOManager.sharedInstance.socket.on(Constants.PARKING_INFO.RESPONSE_PARKING_INFO_HISTORY_BY_ACCOUNT_ID, callback: { (data, ask) in
                    
                    let json = JSON(data)[0]
                    print(self.arrCars)
                    print(self.arrGarages)
                    print(json)
                    
                    self.arrHistory = []
                    if json["result"] == true {
                        for item in json["data"].arrayValue {
                            if item["parkingStatus"].intValue > 1{
                                var xCar: Car = Car.init()
                                var xGarage: Garage = Garage.init()
                                for car in self.arrCars {
                                    if car.id == item["carID"].intValue {
                                        xCar = Car.init(id: car.id, accountID: car.accountID, vehicleNumber: car.vehicleNumber)
                                    }
                                }
                                for gara in self.arrGarages {
                                    if gara.id == item["garageID"].intValue {
                                        xGarage = Garage.init(id: gara.id, name: gara.name, address: gara.address, totalSlot: gara.totalSlot, busySlot: gara.busySlot, locationX: gara.locationX, locationY: gara.locationY, accountID: gara.accountID, timeStart: gara.timeStart, timeEnd: gara.timeEnd, xStatus: gara.xStatus)
                                    }
                                }
                                let xhistory = HistoryParkingInfo.init(
                                    id: item["id"].intValue,
                                    car: xCar,
                                    garage: xGarage,
                                    timeBooked: item["timeBooked"].stringValue,
                                    timeGoIn: item["timeGoIn"].stringValue,
                                    timeGoOut: item["timeGoOut"].stringValue,
                                    parkingStatus: item["parkingStatus"].intValue)
                                self.arrHistory.append(xhistory)
                            }
                            
                        }
                        
                        
                        //let historyRecord = His
                    }
                    self.tableView.reloadData()
                    
                    
                    SocketIOManager.sharedInstance.socket.off(Constants.PARKING_INFO.RESPONSE_PARKING_INFO_HISTORY_BY_ACCOUNT_ID)
                })
                
                //End Load History
                
                SocketIOManager.sharedInstance.socket.off(Constants.Garage.RESPONSE_GET_ALL_GARAGE)
            })
            
            //End Load Garage
            
            SocketIOManager.sharedInstance.socket.off(Constants.Car.RESPONSE_FIND_CAR_BY_ACCOUNT_ID)
        })
        
        
        //End Load Car
        
        
        
        
    }
    
    func setupNavBar() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 64))
        //        navBar.backgroundColor = UIColor.black
        let redPixel = UIImage(named: "background_navbar")
        navBar.setBackgroundImage(redPixel, for: UIBarMetrics.default)
        navBar.isTranslucent = false
        let navItem = UINavigationItem(title: "Lịch sử đỗ xe")
        
        let image = UIImage(named: "ic_cancel")?.withRenderingMode(.alwaysOriginal)
        
        let cancelItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: #selector(clickBtnCancel))
        
        navItem.leftBarButtonItem = cancelItem
        navBar.setItems([navItem], animated: false)
        
        self.view.addSubview(navBar)
    }
    
    func clickBtnCancel() {
        self.dismiss(animated: true, completion: nil)
        print("cancel")
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
    
    
    //============= Override =======================================================================
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "myCellHistory", for: indexPath) as! CustomHistoryCell
        
        cell.lblHistory.text = self.arrHistory[indexPath.row].car.vehicleNumber
        dropShadow(cell.viewInfoHistory)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath)
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
