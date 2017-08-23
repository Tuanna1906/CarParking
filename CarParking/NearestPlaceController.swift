//
//  NearestPlaceController.swift
//  CarParking
//
//  Created by Bonz on 8/3/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit
import SwiftyJSON
import GooglePlaces
import Alamofire

class NearestPlaceController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var locationManager = CLLocationManager()
    
    var arrNearestGarage: [NearestGarage] = []
    //var arrUrl: [String] = []
    
    var locationStart = CLLocation()
    var locationEnd = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //setup
        setupNavBar()
        loadTableViewDefault()
        
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        // Do any additional setup after loading the view.
    }
    
    //============= Function
    
    func loadTableViewDefault() {
        
        SocketIOManager.sharedInstance.socket.emit(Constants.Garage.REQUEST_GET_ALL_GARAGES)
        SocketIOManager.sharedInstance.socket.on(Constants.Garage.RESPONSE_GET_ALL_GARAGE, callback: { (data, ask) in
            
            let json = JSON(data)[0]["Garages"]
            self.arrNearestGarage = []
            
            for item in json.arrayValue {
                
                let origin = "\(self.locationStart.coordinate.latitude),\(self.locationStart.coordinate.longitude)"
                let destination = "\(item["locationX"].doubleValue),\(item["locationY"].doubleValue)"
                let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
                let garage = NearestGarage.init(id: item["id"].intValue,
                                                name: item["name"].stringValue,
                                                address: item["address"].stringValue,
                                                totalSlot: item["totalSlot"].intValue,
                                                busySlot: item["busySlot"].intValue,
                                                locationX: item["locationX"].doubleValue,
                                                locationY: item["locationY"].doubleValue,
                                                accountID: item["accountID"].intValue,
                                                timeStart: item["timeStart"].stringValue,
                                                timeEnd: item["timeEnd"].stringValue,
                                                xStatus: item["xStatus"].intValue, distance: "",distanceValue: 0, duration: "", durationValue: 0, url: url)
                self.arrNearestGarage.append(garage)
            
                Alamofire.request(url).responseJSON { response in
                    let json = JSON(data: response.data!)
                    
                    for item in self.arrNearestGarage {
                        if item.url == String(describing: response.response!.url!){
                            item.distance = json["routes"][0]["legs"][0]["distance"]["text"].stringValue
                            item.duration = json["routes"][0]["legs"][0]["duration"]["text"].stringValue
                            item.distanceValue = json["routes"][0]["legs"][0]["distance"]["value"].intValue
                            item.durationValue = json["routes"][0]["legs"][0]["duration"]["value"].intValue
                            
                        }
                    }
                    self.arrangementTableView()
                    
                }
                
            }
            SocketIOManager.sharedInstance.socket.off(Constants.Garage.RESPONSE_GET_ALL_GARAGE)
        })
        
    }
    
    func arrangementTableView() {
        for a in 0 ..< (arrNearestGarage.count - 1) {
            for b in (a + 1) ..< arrNearestGarage.count {
                if(arrNearestGarage[a].distanceValue > arrNearestGarage[b].distanceValue){
                    let garage = arrNearestGarage[b]
                    arrNearestGarage[b] = arrNearestGarage[a]
                    arrNearestGarage[a] = garage
                }
            }
        }
        self.tableView.reloadData()
    }
    
  
    
    
    
    func setupNavBar() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 64))
//        navBar.backgroundColor = UIColor.black
        let redPixel = UIImage(named: "background_navbar")
        navBar.setBackgroundImage(redPixel, for: UIBarMetrics.default)
        navBar.isTranslucent = false
        let navItem = UINavigationItem(title: "Chọn điểm đỗ")
        
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
    
    
    //============= Override
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - Location Manager delegates
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get location : \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let latestLocation: CLLocation = locations[locations.count - 1]
        
        
        self.locationStart = CLLocation(latitude: latestLocation.coordinate.latitude, longitude: latestLocation.coordinate.longitude)
        
        self.locationManager.stopUpdatingLocation()
        //let distanceBetween: CLLocationDistance =latestLocation.distance(from: startLocation)
        
        //print(String(format: "%.2f", distanceBetween))
    }
    
    //============= MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrNearestGarage.count < 10 {
            return self.arrNearestGarage.count
        }else{
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "myCellNearestPlace", for: indexPath) as! CustomNearestPlaceCell
        if(self.arrNearestGarage.count > 0){
            cell.lblNameGarage.text = self.arrNearestGarage[indexPath.row].name
            cell.lblAddress.text = self.arrNearestGarage[indexPath.row].address
            cell.lblDistance.text = self.arrNearestGarage[indexPath.row].distance
            cell.lblDuration.text = self.arrNearestGarage[indexPath.row].duration
            cell.lblTotalSlot.text = String(self.arrNearestGarage[indexPath.row].totalSlot) + " chỗ"
            cell.lblEmptySlot.text = String(self.arrNearestGarage[indexPath.row].totalSlot - self.arrNearestGarage[indexPath.row].busySlot)
            dropShadow(cell.viewInfoPlace)
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
    
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    //    {
    //        if editingStyle == .delete
    //        {
    //            names.remove(at: indexPath.row)
    //            address.remove(at: indexPath.row)
    //            tableView.reloadData()
    //        }
    //    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
