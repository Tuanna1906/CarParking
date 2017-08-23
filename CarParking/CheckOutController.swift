//
//  CheckOutController.swift
//  CarParking
//
//  Created by Bonz on 8/21/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit
import SwiftyJSON

class CheckOutController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    var arrCheckOut:[CheckInParkingInfo] = []
    
    var filteredDate = [CheckInParkingInfo]()
    
    let searchController = UISearchController(searchResultsController: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavBar()
        self.loadViewDefault()
        self.setUpSearch()
        // Do any additional setup after loading the view.
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
        SocketIOManager.sharedInstance.socket.emit(Constants.PARKING_INFO.REQUEST_CAR_GO_OUT, Instances.sharedInstance.garageID)
        SocketIOManager.sharedInstance.socket.on(Constants.PARKING_INFO.RESPONSE_CAR_GO_OUT, callback: { (data, ask) in
            
            self.arrCheckOut = []
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
                    self.arrCheckOut.append(checkInInfo)
                }
                
            }
            self.filteredDate = self.arrCheckOut
            self.tableView.reloadData()
            
            SocketIOManager.sharedInstance.socket.off(Constants.PARKING_INFO.RESPONSE_CAR_GO_OUT)
        })
        
    }
    func setUpSearch() {
        self.filteredDate = arrCheckOut
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
        let navItem = UINavigationItem(title: "CheckOut")
        
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }
    
    //============= MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        
        
        if searchController.searchBar.text! == ""{
            filteredDate = arrCheckOut
        }else{
            filteredDate = arrCheckOut.filter({$0.vehicleNumber.lowercased().contains(searchController.searchBar.text!.lowercased())})
        }
        self.tableView.reloadData()
    }


    
    
    //============= MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filteredDate.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "myCellCheckOut", for: indexPath) as! CustomCheckOutCell
        if(self.arrCheckOut.count > 0){
            cell.carNumber.text = self.filteredDate[indexPath.row].vehicleNumber
            cell.timeBooking.text = self.filteredDate[indexPath.row].timeBooked
            cell.timeGoIn.text = self.filteredDate[indexPath.row].timeGoIn
            cell.btnCheckOut.tag =  self.filteredDate[indexPath.row].id
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

extension CheckOutController: CustomCheckOutCellDelegate{
    func didTapCheckOut(_ sender: UIButton) {
       
        SocketIOManager.sharedInstance.socket.emit(Constants.PARKING_INFO.REQUEST_CAR_OUT, sender.tag, Instances.sharedInstance.garageID)
        SocketIOManager.sharedInstance.socket.on(Constants.PARKING_INFO.RESPONSE_CAR_OUT, callback: { (data, ask) in
            
            
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
            
            SocketIOManager.sharedInstance.socket.off(Constants.PARKING_INFO.RESPONSE_CAR_OUT)
        })
        
    }
}

