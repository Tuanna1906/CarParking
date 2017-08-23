//
//  BookingController.swift
//  CarParking
//
//  Created by Bonz on 8/2/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit
import SwiftyJSON
import GoogleMaps
import GooglePlaces
import Alamofire
import SCLAlertView

class BookingController: UIViewController, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //
    @IBOutlet weak var mapViewBooking: GMSMapView!
    @IBOutlet weak var pickerVehicleNumber: UIPickerView!
    @IBOutlet weak var btnAddCar: UIButton!
    @IBOutlet weak var btnBooking: CustomButton!
    
    var vehicleNumberList: [String] = []
    var carIDList: [Int] = []
    var carIDSelected = -1
    
    var locationManager = CLLocationManager()
    var locationStart = CLLocation()
    var locationEnd = CLLocation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect data:
        self.pickerVehicleNumber.delegate = self
        self.pickerVehicleNumber.dataSource = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //setup
        setupNavBar()
        loadGaraSelected()
        
        // Do any additional setup after loading the view.
    }
    
    func loadGaraSelected(){
        //default camera
        let camera = GMSCameraPosition.camera(withLatitude: 21.025817, longitude: 105.851701, zoom: 13)
        mapViewBooking.camera = camera
        
        SocketIOManager.sharedInstance.socket.emit(Constants.Garage.REQUEST_GET_GARAGE_BY_ID, Instances.sharedInstance.selectedGarageID)
        SocketIOManager.sharedInstance.socket.on(Constants.Garage.RESPONSE_GET_GARAGE_BY_ID, callback: { (data, ask) in
            
            let json = JSON(data)[0]["data"][0]
            print(json)
            //loadMapView
            let lat = json["locationX"].doubleValue
            let long = json["locationY"].doubleValue
            let cameraUpdate = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17)
            
            //get value create marker
            //let totalSlot = json["totalSlot"].intValue
            let emptySlot = json["totalSlot"].intValue - json["busySlot"].intValue
            
            var atPoint = CGPoint(x: 10,y: 7)
            if emptySlot < 10 {
                atPoint = CGPoint(x: 14,y: 7)
            }else if emptySlot < 20 {
                atPoint = CGPoint(x: 11,y: 7)
            }
            //icon marker
            let image = self.textToImage(drawText: String(emptySlot) as NSString, inImage: UIImage(named:"ic_place_red")!,textColor: .red ,atPoint: atPoint)
            let markerView = UIImageView(image: image)
            
            let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            //marker
            let marker = GMSMarker(position: position)
            marker.iconView = markerView
            marker.tracksViewChanges = true
            marker.map = self.mapViewBooking
            
            self.mapViewBooking.camera = cameraUpdate
            
            //get distance duration
            let origin = "\(self.locationStart.coordinate.latitude),\(self.locationStart.coordinate.longitude)"
            let destination = "\(lat),\(long)"
            let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
            
            Alamofire.request(url).responseJSON { response in
                let json = JSON(data: response.data!)
                
                print(json["routes"][0]["legs"][0]["distance"]["text"].stringValue)
                print(json["routes"][0]["legs"][0]["duration"]["text"].stringValue)
                
            }
            
            SocketIOManager.sharedInstance.socket.off(Constants.Garage.RESPONSE_GET_GARAGE_BY_ID)
            
        })
        
        //load car
        self.loadAllCar()
        
        
    }
    
    func loadAllCar(){
        //load car
        SocketIOManager.sharedInstance.socket.emit(Constants.Car.REQUEST_FIND_CAR_BY_ACCOUNT_ID, Instances.sharedInstance.accountID)
        
        SocketIOManager.sharedInstance.socket.on(Constants.Car.RESPONSE_FIND_CAR_BY_ACCOUNT_ID, callback: { (data, ask) in
            self.vehicleNumberList = []
            self.carIDList = []
            
            let json = JSON(data)[0]["data"]
            
            let arr = json.arrayValue
            
            for item in arr {
                self.vehicleNumberList.append(item["vehicleNumber"].stringValue)
                self.carIDList.append(item["id"].intValue)
            }
            self.pickerVehicleNumber.reloadAllComponents()
            
            if(self.vehicleNumberList.count == 5){
                self.btnAddCar.isHidden = true
            }
            if self.carIDList.count > 0 {
                self.carIDSelected  = self.carIDList[self.pickerVehicleNumber.selectedRow(inComponent: 0)]
                self.btnBooking.isEnabled = true
            }else{
                self.btnBooking.isEnabled = false
            }
            SocketIOManager.sharedInstance.socket.off(Constants.Car.RESPONSE_FIND_CAR_BY_ACCOUNT_ID)
            
        })
        
        
    }
    
    func textToImage(drawText: NSString, inImage: UIImage,textColor: UIColor?, atPoint: CGPoint) -> UIImage{
        
        // Setup the font specific variables
        let textColor = textColor!
        let textFont = UIFont.systemFont(ofSize: 15)
        
        // Setup the image context using the passed image
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, scale)
        
        // Setup the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ] as [String : Any]
        
        // Put the image into a rectangle as large as the original image
        inImage.draw(in: CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height))
        
        // Create a point within the space that is as bit as the image
        let rect = CGRect(x: atPoint.x, y: atPoint.y, width: inImage.size.width,height: inImage.size.height)
        
        // Draw the text into an image
        drawText.draw(in: rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //Pass the image back up to the caller
        return newImage!
        
    }
    
    
    func setupNavBar() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 64))
        //        navBar.backgroundColor = UIColor.black
        let redPixel = UIImage(named: "background_navbar")
        navBar.setBackgroundImage(redPixel, for: UIBarMetrics.default)
        navBar.isTranslucent = false
        let navItem = UINavigationItem(title: "Đặt chỗ")
        
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

    
    // Button
    @IBAction func clickBtnBooking(_ sender: UIButton) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let garageID = Instances.sharedInstance.selectedGarageID
        let dateString = formatter.string(from: date)
        
        
        SocketIOManager.sharedInstance.socket.emit(Constants.PARKING_INFO.REQUEST_ADD_NEW_PARKING_INFO_BY_USER, self.carIDSelected, garageID, dateString, 0)
        SocketIOManager.sharedInstance.socket.on(Constants.PARKING_INFO.RESPONSE_ADD_NEW_PARKING_INFO_BY_USER, callback: { (data, ask) in
            let json = JSON(data)[0]
            if(json["result"].boolValue == true){
                self.showAlertSuccess(title: "Thành công", subTitle: "Đặt chỗ thành công", button: "Đóng")
            }
            print(json)
            SocketIOManager.sharedInstance.socket.off(Constants.PARKING_INFO.RESPONSE_ADD_NEW_PARKING_INFO_BY_USER)
        })
        
        
        
        
    }
    
    @IBAction func clickAddVehicleNumber(_ sender: UIButton) {
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
                    self.loadAllCar()
                }
                SocketIOManager.sharedInstance.socket.off(Constants.Car.RESPONSE_ADD_NEW_CAR)
            })
        }
        alert.addButton("Đóng"){}
        alert.showEdit("", subTitle: "Thêm biển số xe")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Picker delegates and data
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return vehicleNumberList.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return vehicleNumberList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.carIDList.count > 0 {
            self.carIDSelected = carIDList[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = self.vehicleNumberList[row]
        
        // pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
        pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 50) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
