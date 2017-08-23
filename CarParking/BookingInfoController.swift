//
//  BookingInfoController.swift
//  CarParking
//
//  Created by Bonz on 8/23/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit
import SwiftyJSON
import GoogleMaps
import GooglePlaces
import Alamofire
import SCLAlertView

class BookingInfoController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lblGaraName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblSlot: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    
    
    var locationManager = CLLocationManager()
    var locationStart = CLLocation()
    var locationEnd = CLLocation()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Connect data:
        
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        //setup
        setupNavBar()
        loadGaraSelected()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Action button
    @IBAction func ReBookingTapped(_ sender: UIButton) {
        sender.pulsate()
        SocketIOManager.sharedInstance.socket.emit(Constants.PARKING_INFO.REQUEST_REFRESH_BOOKING_TIMEOUT, Instances.sharedInstance.bookingInfoID, 3)
        SocketIOManager.sharedInstance.socket.on(Constants.PARKING_INFO.RESPONSE_REFRESH_BOOKING_TIMEOUT, callback: { (data, ask) in
            
            let json = JSON(data)[0]
            print(json)
            if json["result"].boolValue == true {
                self.showAlertSuccess(title: "Thành công", subTitle: "Đặt chỗ thành công", button: "Đóng")
                
            }
            
            SocketIOManager.sharedInstance.socket.off(Constants.PARKING_INFO.RESPONSE_REFRESH_BOOKING_TIMEOUT)
            
        })

    }
    
    @IBAction func CancelBookingTapped(_ sender: UIButton) {
        sender.pulsate()
        SocketIOManager.sharedInstance.socket.emit(Constants.PARKING_INFO.REQUEST_EDIT_PARKING_INFO_BY_ID_STATUS, Instances.sharedInstance.bookingInfoID, 3)
        SocketIOManager.sharedInstance.socket.on(Constants.PARKING_INFO.RESPONSE_EDIT_PARKING_INFO_BY_ID_STATUS, callback: { (data, ask) in
            
            let json = JSON(data)[0]
            if json["result"].boolValue == true {
                self.showAlertSuccess(title: "Thành công", subTitle: "Hủy đặt chỗ thành công", button: "Đóng")
                
            }
            
            SocketIOManager.sharedInstance.socket.off(Constants.PARKING_INFO.RESPONSE_EDIT_PARKING_INFO_BY_ID_STATUS)
            
        })
        
    }
    
    //func 
    
    
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
    
    func setupNavBar() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 64))
        //        navBar.backgroundColor = UIColor.black
        let redPixel = UIImage(named: "background_navbar")
        navBar.setBackgroundImage(redPixel, for: UIBarMetrics.default)
        navBar.isTranslucent = false
        let navItem = UINavigationItem(title: "Thông tin đặt chỗ")
        
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


    func loadGaraSelected(){
        //default camera
        let camera = GMSCameraPosition.camera(withLatitude: 21.025817, longitude: 105.851701, zoom: 13)
        mapView.camera = camera
        
        SocketIOManager.sharedInstance.socket.emit(Constants.Garage.REQUEST_GET_GARAGE_BY_ID, Instances.sharedInstance.garageIDBooking)
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
            
            //setdata
            self.lblGaraName.text = json["name"].stringValue
            self.lblAddress.text = json["address"].stringValue
            self.lblSlot.text = "Còn \(emptySlot) / \(json["totalSlot"].intValue) chỗ"
            
            //icon marker
            let image = self.textToImage(drawText: String(emptySlot) as NSString, inImage: UIImage(named:"ic_place_red")!,textColor: .red ,atPoint: atPoint)
            let markerView = UIImageView(image: image)
            
            let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            //marker
            let marker = GMSMarker(position: position)
            marker.iconView = markerView
            marker.tracksViewChanges = true
            marker.map = self.mapView
            
            self.mapView.camera = cameraUpdate
            
            //get distance duration
            let origin = "\(self.locationStart.coordinate.latitude),\(self.locationStart.coordinate.longitude)"
            let destination = "\(lat),\(long)"
            let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
            
            Alamofire.request(url).responseJSON { response in
                let json = JSON(data: response.data!)
                
                print(json["routes"][0]["legs"][0]["distance"]["text"].stringValue)
                print(json["routes"][0]["legs"][0]["duration"]["text"].stringValue)
                self.lblTime.text = json["routes"][0]["legs"][0]["duration"]["text"].stringValue
                self.lblDistance.text = json["routes"][0]["legs"][0]["distance"]["text"].stringValue
                
            }

            
            SocketIOManager.sharedInstance.socket.off(Constants.Garage.RESPONSE_GET_GARAGE_BY_ID)
            
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
