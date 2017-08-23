//
//  SuperAdminController.swift
//  CarParking
//
//  Created by Bonz on 8/22/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit
import SwiftyJSON

class SuperAdminController: UIViewController , UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating{
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrGarage:[GarageAdmin] = []
    var filteredDate = [GarageAdmin]()
    var garageSelected = GarageAdmin()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadTableViewDefault()
        self.setUpSearch()
        
        let navBar = self.navigationController?.navigationBar
        navBar?.isTranslucent = false
        
        let redPixel = UIImage(named: "background_navbar")
        navBar?.setBackgroundImage(redPixel, for: UIBarMetrics.default)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addGaraTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "gotoRegisterAdminScreen", sender: self)
    }
    
    
    @IBAction func btnLogoutTapped(_ sender: UIBarButtonItem) {
//        self.resetInstances()
//        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
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
        Instances.sharedInstance.newAdmin = ""
        Instances.sharedInstance.newAdminId = -1
        UserDefaults.standard.set("", forKey: "tokenLogin")
    }

    
    
    //============= Function
    
    func loadTableViewDefault() {
        
        SocketIOManager.sharedInstance.socket.emit(Constants.Garage.REQUEST_GET_ALL_GARAGES_AND_ADMIN)
        SocketIOManager.sharedInstance.socket.on(Constants.Garage.RESPONSE_GET_ALL_GARAGES_AND_ADMIN, callback: { (data, ask) in
            
            let json = JSON(data)[0]
            self.arrGarage = []
            if json["result"].boolValue == true{
                for item in json["data"].arrayValue {
                    
                    let garage = GarageAdmin.init(id: item["id"].intValue,
                                                  name: item["name"].stringValue,
                                                  address: item["address"].stringValue,
                                                  totalSlot: item["totalSlot"].intValue,
                                                  busySlot: item["busySlot"].intValue,
                                                  locationX: item["locationX"].doubleValue,
                                                  locationY: item["locationY"].doubleValue,
                                                  accountID: item["accountID"].intValue,
                                                  timeStart: item["timeStart"].stringValue,
                                                  timeEnd: item["timeEnd"].stringValue,
                                                  xStatus: item["xStatus"].intValue,
                                                  email: item["email"].stringValue)
                    self.arrGarage.append(garage)
                    
                }
            }
            self.filteredDate = self.arrGarage
            self.tableView.reloadData()
            SocketIOManager.sharedInstance.socket.off(Constants.Garage.RESPONSE_GET_ALL_GARAGES_AND_ADMIN)
        })
        
    }
    
    func setUpSearch() {
        self.filteredDate = arrGarage
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func nextScreen(_ screen: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: screen) // MySecondSecreen the storyboard ID
        self.present(vc, animated: true, completion: nil)
    }
    
    //============= MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text! == ""{
            filteredDate = arrGarage
        }else{
            filteredDate = arrGarage.filter({$0.name.lowercased().contains(searchController.searchBar.text!.lowercased())})
        }
        self.tableView.reloadData()
    }
    
    // Mark: Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "myCellGarage", for: indexPath) as! CustomGarageCell
        cell.garageName.text = self.filteredDate[indexPath.row].name
        cell.address.text = self.filteredDate[indexPath.row].address
        cell.admin.text = self.filteredDate[indexPath.row].email
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.garageSelected =  self.filteredDate[indexPath.row]
        performSegue(withIdentifier: "gotoDetailGarageScreen", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            
            SocketIOManager.sharedInstance.socket.emit(Constants.Account.REQUEST_REMOVE_ACCOUNT_BY_ID, self.filteredDate[indexPath.row].accountID)
            SocketIOManager.sharedInstance.socket.on(Constants.Account.RESPONSE_REMOVE_ACCOUNT_BY_ID, callback: { (data, ask) in
                
                let json = JSON(data)[0]
                print(json)
                if(json["result"].boolValue == true){
                    var index:Int = -1
                    
                    for i in 0 ..< self.arrGarage.count {
                        if self.arrGarage[i].id == self.filteredDate[indexPath.row].id{
                            index = i
                        }
                    }
                    self.arrGarage.remove(at: index)
                    self.filteredDate.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
                
                SocketIOManager.sharedInstance.socket.off(Constants.Account.RESPONSE_REMOVE_ACCOUNT_BY_ID)
            })
            
        }
    }

    
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "gotoDetailGarageScreen") {
            
            if let detailGarageController = segue.destination as? DetailGarageController {
                detailGarageController.passData = self.garageSelected
            }
        }
    }
    
    
    
    
    
}
