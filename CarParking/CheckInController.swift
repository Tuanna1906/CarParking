//
//  CheckInController.swift
//  CarParking
//
//  Created by Bonz on 8/20/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit
import SwiftyJSON
import SCLAlertView

class CheckInController: UIViewController, UITableViewDelegate, UITableViewDataSource , UISearchResultsUpdating{
    
    @IBOutlet weak var tableView: UITableView!
    var arrCheckIn: [CheckInParkingInfo] = []
    
    var filteredDate = [CheckInParkingInfo]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavBar()
        self.loadViewDefault()
        self.setUpSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
        self.loadViewDefault()
        // Hide the navigation bar on the this view controller
        //self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //func
    func loadViewDefault() {
        SocketIOManager.sharedInstance.socket.emit(Constants.PARKING_INFO.REQUEST_CAR_GO_IN, Instances.sharedInstance.garageID)
        SocketIOManager.sharedInstance.socket.on(Constants.PARKING_INFO.RESPONSE_CAR_GO_IN, callback: { (data, ask) in
            
            self.arrCheckIn = []
            let json = JSON(data)[0]
            
            if json["result"].boolValue == true {
                for item in json["data"].arrayValue {
                    let checkInInfo = CheckInParkingInfo.init(
                        id: item["id"].intValue,
                        carID: item["carID"].intValue,
                        garageID: item["garageID"].intValue,
                        timeBooked: item["timeBooked"].stringValue,
                        timeGoIn: item["timeGoIn"].stringValue,
                        timeGoOut: item["timeGoOut"].stringValue,
                        parkingStatus: item["parkingStatus"].intValue,
                        vehicleNumber: item["vehicleNumber"].stringValue)
                    self.arrCheckIn.append(checkInInfo)
                }
                
            }
            
            
            self.filteredDate = self.arrCheckIn
            self.tableView.reloadData()
            SocketIOManager.sharedInstance.socket.off(Constants.PARKING_INFO.RESPONSE_CAR_GO_IN)
        })
        
    }
    
    func setUpSearch() {
        self.filteredDate = arrCheckIn
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    
    func setupNavBar() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 64))
        //        navBar.backgroundColor = UIColor.black
        let redPixel = UIImage(named: "background_navbar")
        navBar.setBackgroundImage(redPixel, for: UIBarMetrics.default)
        navBar.isTranslucent = false
        let navItem = UINavigationItem(title: "CheckIn")
        let image = UIImage(named: "ic_add")?.withRenderingMode(.alwaysOriginal)
        
        let cancelItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: #selector(clickBtnAdd))
        
        navItem.rightBarButtonItem = cancelItem
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }
    
    func clickBtnAdd() {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        let txtVehicleNumber = alert.addTextField("Nhập biển số xe")
        alert.addButton("Xác nhận") {
            let vehicleNumberNew = txtVehicleNumber.text
            SocketIOManager.sharedInstance.socket.emit(Constants.PARKING_INFO.REQUEST_CAR_IN_NUMBER, vehicleNumberNew!, Instances.sharedInstance.accountID, Instances.sharedInstance.garageID)
            SocketIOManager.sharedInstance.socket.on(Constants.PARKING_INFO.RESPONSE_CAR_IN, callback: { (data, ask) in
                let json = JSON(data)[0]
                if(json["result"].boolValue == true){
                   
                }
                SocketIOManager.sharedInstance.socket.off(Constants.PARKING_INFO.RESPONSE_CAR_IN)
            })
        }
        alert.addButton("Đóng"){}
        alert.showEdit("", subTitle: "Thêm biển số xe")

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
    
    //============= MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
       
        if searchController.searchBar.text! == ""{
            filteredDate = arrCheckIn
        }else{
            filteredDate = arrCheckIn.filter({$0.vehicleNumber.lowercased().contains(searchController.searchBar.text!.lowercased())})
        }
        self.tableView.reloadData()
    }
    
    //============= MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filteredDate.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "myCellCheckIn", for: indexPath) as! CustomCheckInCell
        if(self.arrCheckIn.count > 0){
            cell.numberCar.text = self.filteredDate[indexPath.row].vehicleNumber
            cell.timeBooking.text = self.filteredDate[indexPath.row].timeBooked
            cell.btnCheckIn.tag = self.filteredDate[indexPath.row].id
            cell.delegate = self
            
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
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension CheckInController: CustomCheckInCellDelegate{
    func didTapCheckIn(_ sender: UIButton) {
        
        SocketIOManager.sharedInstance.socket.emit(Constants.PARKING_INFO.REQUEST_CAR_IN_ID, sender.tag, Instances.sharedInstance.garageID)
        SocketIOManager.sharedInstance.socket.on(Constants.PARKING_INFO.RESPONSE_CAR_IN, callback: { (data, ask) in
            
            
            let json = JSON(data)[0]
            if json["result"].boolValue == true {
                self.loadViewDefault()
            }
            //            if json["result"].boolValue == true {
            //                for item in json["data"].arrayValue {
            //                    self.arrVehicleNumber.append(item["vehicleNumber"].stringValue)
            //                    self.timeBooked.append(item["timeBooked"].stringValue)
            //                }
            //            }
            //            self.tableView.reloadData()
            
            SocketIOManager.sharedInstance.socket.off(Constants.PARKING_INFO.RESPONSE_CAR_IN)
        })
        
    }
}
