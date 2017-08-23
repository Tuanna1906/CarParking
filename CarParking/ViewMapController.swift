//
//  ViewMapController.swift
//  CarParking
//
//  Created by Bonz on 6/27/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit
import SideMenu
import SwiftyJSON
import GoogleMaps
import GooglePlaces
import Alamofire

class ViewMapController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    //========== IBOutlet ===================================================
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var customViewInfo: UIView!
    @IBOutlet weak var customMenuView: UIView!
    
    @IBOutlet weak var btnDirection: CustomButton!
    @IBOutlet weak var btnMyLocation: UIButton!
    @IBOutlet weak var btnBooking: CustomButton!
    @IBOutlet weak var lblNameGarage: UILabel!
    @IBOutlet weak var lblAddressGarage: UILabel!
    @IBOutlet weak var lblEmptySlot: UILabel!
    @IBOutlet weak var lblTotalSlot: UILabel!
    
    var isSelectedMarker = false
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    var arrGarages: [Garage] = []
    var arrMarker: [GMSMarker] = []
    var selectedMarkerOld: GMSMarker? = nil
    var selectMarker = false
    var firstTime = true
    var firstTimeCheckBooking = true
    var isBooking = false
    
    //==========           ===================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil
        
        mapView.delegate = self
        setupSideMenu()
        defaultCameraMap()
        loadMapViewDefault()
        
        
        dropShadow(customViewInfo)
        dropShadow(customMenuView)
        dropShadow(btnMyLocation)
        dropShadow(btnDirection)
        self.customViewInfo.isHidden = true
     
       
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        if let destinationVC = segue.destination as? MenuController {
//            
//            //destinationVC.viewMap = self
//            
//        }
//    }
    
    fileprivate func setupSideMenu(){
        // Define the menus
        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the view controller it displays!
        //SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        //SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        //Style
        SideMenuManager.menuPresentMode = .menuSlideIn
        //SideMenuManager.menuBlurEffectStyle = .dark
        SideMenuManager.menuAnimationFadeStrength = 0.1
        SideMenuManager.menuAnimationTransformScaleFactor = 0.950
        SideMenuManager.menuFadeStatusBar = false
        
    }
    
    func onSocket() {
        SocketIOManager.sharedInstance.socket.on(Constants.Garage.RESPONSE_GARAGE_UPDATED, callback: { (data, ask) in
            
            let json = JSON(data)[0]
            
            if json["result"] == true {
                self.loadMapViewDefault()
            }

            
        })

    }
    
    //========== IBAction
    @IBAction func clickBtnSearch(_ sender: Any) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        
        //acController.secondaryTextColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
        acController.secondaryTextColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        acController.primaryTextColor = UIColor.lightGray
        acController.primaryTextHighlightColor = UIColor.gray
        acController.tableCellBackgroundColor = UIColor.darkGray
        acController.tableCellSeparatorColor = UIColor.lightGray
        acController.tintColor = UIColor.lightGray
        
        present(acController, animated: true, completion: nil)
        
    }
    
    @IBAction func clickBtnBooking(_ sender: UIButton) {
        sender.pulsate()
        if self.isBooking == true {
            nextScreen("BookingInfoScreen")
        }else{
            if selectedMarkerOld == nil{
                nextScreen("FindNearestPointScreen")
            }else{
                let garaSelect = selectedMarkerOld?.userData as! Garage
                
                Instances.sharedInstance.selectedGarageID = garaSelect.id
                
                nextScreen("BookingScreen")
            }
        }
        
    }
    
    @IBAction func clickBtnMyLocation(_ sender: UIButton) {
        sender.pulsate()
        guard let lat = self.mapView.myLocation?.coordinate.latitude,
            let lng = self.mapView.myLocation?.coordinate.longitude else { return }
        
        let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: lng , zoom: self.mapView.camera.zoom)
        self.mapView.animate(to: camera)
    }
    
    @IBAction func clickBtnDirection(_ sender: UIButton) {
        sender.pulsate()
        
    }
    
    //    @IBAction func clickBtnMenu(_ sender: UIButton) {
    //        let storyboard = UIStoryboard(name: "Main", bundle: nil);
    //        let vc = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") // MySecondSecreen the storyboard ID
    //        self.present(vc, animated: true, completion: nil);
    //    }
    
    //========== Function
    
    func nextScreen(_ screen: String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: screen) // MySecondSecreen the storyboard ID
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil);
    }
    
    func defaultCameraMap() {
        //default camera
        let camera = GMSCameraPosition.camera(withLatitude: 21.025817, longitude: 105.851701, zoom: 13)
        mapView.camera = camera
        
        // GOOGLE MAPS SDK: USER'S LOCATION
        mapView.isMyLocationEnabled = true

    }
    func loadMapViewDefault() {
        
        
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
            
            self.loadIconMarkerDefault()
            
            self.checkBooking()
            
            if self.firstTime == true{
                self.onSocket()
                self.firstTime = false
            }
            SocketIOManager.sharedInstance.socket.off(Constants.Garage.RESPONSE_GET_ALL_GARAGE)
        })
        
    }
    
    func checkBooking() {
        SocketIOManager.sharedInstance.socket.emit(Constants.PARKING_INFO.REQUEST_PARKING_INFO_BY_ACCOUNT_ID, Instances.sharedInstance.accountID)
        SocketIOManager.sharedInstance.socket.on(Constants.PARKING_INFO.RESPONSE_PARKING_INFO_BY_ACCOUNT_ID, callback: { (data, ask) in
            
            let json = JSON(data)[0]
            print(json)
            // is Booking
            if json["result"].boolValue == true {
                if json["result"].boolValue == true {
                    for gara in self.arrGarages{
                        if gara.id == json["data"]["garageID"].intValue {
                            //print(gara)
                            let origin = "\(self.startLocation.coordinate.latitude),\(self.startLocation.coordinate.longitude)"
                            let destination = "\(gara.locationX),\(gara.locationY)"
                            self.drawPath(origin: origin, destination: destination)
                            if self.firstTimeCheckBooking == true {
                                let camera = GMSCameraPosition.camera(withLatitude: self.startLocation.coordinate.latitude, longitude: self.startLocation.coordinate.longitude, zoom: 13)
                                self.mapView.camera = camera
                                self.firstTimeCheckBooking = false
                            }
                            
                        }
                    }
                    Instances.sharedInstance.garageIDBooking = json["data"]["garageID"].intValue
                    Instances.sharedInstance.bookingInfoID = json["data"]["id"].intValue
                    
                }
                self.isBooking = true
                self.btnBooking.setTitle("Hủy đặt chỗ", for: .normal)
            }else{
                self.isBooking = false
                self.btnBooking.setTitle("TÌM ĐIỂM ĐỖ GẦN NHẤT", for: .normal)
            }
            
            SocketIOManager.sharedInstance.socket.off(Constants.PARKING_INFO.RESPONSE_PARKING_INFO_BY_ACCOUNT_ID)
        })

    }
    
    func drawPath(origin: String, destination: String)
    {
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        
        Alamofire.request(url).responseJSON { response in
            
            
            let json = JSON(data: response.data!)
            let routes = json["routes"].arrayValue
            
            // print route using Polyline
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 4
                polyline.strokeColor = UIColor.black
                polyline.map = self.mapView
            }
            
        }
    }
    
    func loadIconMarkerDefault() {
        if self.arrMarker.count != 0 {
            self.mapView.clear()
        }
        
        self.arrMarker = []
        for item in self.arrGarages{
            var atPoint = CGPoint(x: 10,y: 7)
            if (item.totalSlot - item.busySlot) < 10 {
                atPoint = CGPoint(x: 14,y: 7)
            }else if(item.totalSlot - item.busySlot) < 20 {
                atPoint = CGPoint(x: 11,y: 7)
            }
            
            let image = self.textToImage(drawText: String(item.totalSlot - item.busySlot) as NSString, inImage: UIImage(named:"ic_place_yellow")!,textColor: UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1) ,atPoint: atPoint)
            let markerView = UIImageView(image: image)
            //markerView.tintColor = .red
            
            let position = CLLocationCoordinate2D(latitude: item.locationX, longitude: item.locationY)
            let marker = GMSMarker(position: position)
            marker.userData = item
            marker.iconView = markerView
            marker.tracksViewChanges = true
            marker.map = self.mapView
            
            self.arrMarker.append(marker)
            
        }
        
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
    
    
    func dropShadow(_ view: UIView) {
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 20
        view.layer.masksToBounds = false
        
        
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        //view.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dismissViewMap() {
        dismiss(animated: true, completion: nil)
    }
    
    //========== override & delegate
    
    //Click any on map
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if self.selectedMarkerOld != nil {
            let garaOld = selectedMarkerOld?.userData as! Garage
            var atPoint = CGPoint(x: 10,y: 7)
            if (garaOld.totalSlot - garaOld.busySlot) < 10 {
                atPoint = CGPoint(x: 14,y: 7)
            }else if(garaOld.totalSlot - garaOld.busySlot) < 20 {
                atPoint = CGPoint(x: 11,y: 7)
            }
            let image = self.textToImage(drawText: String(garaOld.totalSlot - garaOld.busySlot) as NSString, inImage: UIImage(named:"ic_place_yellow")!,textColor: UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1) ,atPoint: atPoint)
            let markerView = UIImageView(image: image)
            self.selectedMarkerOld?.iconView = markerView
        }
        self.selectedMarkerOld = nil
        
        
        
        self.customViewInfo.isHidden = true
        self.lblNameGarage.text = ""
        self.lblAddressGarage.text = ""
        self.lblEmptySlot.text = "0"
        self.lblTotalSlot.text = "/ " + "0" + " chỗ"
        self.isSelectedMarker = false
        if self.isBooking == false {
        self.btnBooking.setTitle("TÌM ĐIỂM ĐỖ GẦN NHẤT", for: .normal)
        }
    }
    
    
    //Click select marker
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        //change icon marker select old
        if self.selectedMarkerOld != nil {
            let garaOld = selectedMarkerOld?.userData as! Garage
            var atPoint = CGPoint(x: 10,y: 7)
            if (garaOld.totalSlot - garaOld.busySlot) < 10 {
                atPoint = CGPoint(x: 14,y: 7)
            }else if(garaOld.totalSlot - garaOld.busySlot) < 20 {
                atPoint = CGPoint(x: 11,y: 7)
            }
            let image = self.textToImage(drawText: String(garaOld.totalSlot - garaOld.busySlot) as NSString, inImage: UIImage(named:"ic_place_yellow")!,textColor: UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1) ,atPoint: atPoint)
            let markerView = UIImageView(image: image)
            self.selectedMarkerOld?.iconView = markerView
        }
        self.selectedMarkerOld = marker
        
        
        //get data marker New
        self.customViewInfo.isHidden = false
        let positionX = marker.position.latitude
        let positionY = marker.position.longitude
        let camera = GMSCameraPosition.camera(withLatitude: positionX ,longitude: positionY , zoom: self.mapView.camera.zoom)
        self.mapView.animate(to: camera)
        let gara = marker.userData as! Garage
        
        //change icon marker
        var atPoint = CGPoint(x: 10,y: 7)
        if (gara.totalSlot - gara.busySlot) < 10 {
            atPoint = CGPoint(x: 14,y: 7)
        }else if(gara.totalSlot - gara.busySlot) < 20 {
            atPoint = CGPoint(x: 11,y: 7)
        }
        let image = self.textToImage(drawText: String(gara.totalSlot - gara.busySlot) as NSString, inImage: UIImage(named:"ic_place_blue")!,textColor: UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1),atPoint: atPoint)
        let markerView = UIImageView(image: image)
        marker.iconView = markerView
        
        //show view info Gara
        self.lblNameGarage.text = gara.name
        self.lblAddressGarage.text = gara.address
        self.lblEmptySlot.text = String(gara.totalSlot - gara.busySlot)
        self.lblTotalSlot.text = "/ " + String(gara.totalSlot) + " chỗ"
        self.isSelectedMarker = true
        if self.isBooking == false {
        self.btnBooking.setTitle("CHỌN", for: .normal)
        }
        
        return true
    }
    
    
    //MARK: - Location Manager delegates
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get location : \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let latestLocation: CLLocation = locations[locations.count - 1]
        
        
        //print(String(format: "%.4f", latestLocation.coordinate.latitude))
        //print(String(format: "%.4f",latestLocation.coordinate.longitude))
        let camera = GMSCameraPosition.camera(withLatitude: latestLocation.coordinate.latitude ,longitude: latestLocation.coordinate.longitude , zoom: self.mapView.camera.zoom)
        self.mapView.animate(to: camera)
        
        if startLocation == nil {
            startLocation = latestLocation
        }
        
        self.locationManager.stopUpdatingLocation()
        //let distanceBetween: CLLocationDistance =latestLocation.distance(from: startLocation)
        
        //print(String(format: "%.2f", distanceBetween))
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.loadMapViewDefault()
        // Hide the navigation bar on the this view controller
        //self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//========== extension GMSAutocompleteViewControllerDelegate ====================================================
extension ViewMapController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        //print("Place name: \(place.name)")
        //print("Place address: \(place.formattedAddress!)")
        //print("Place attributions: \(place.attributions!)")
        //print("Place x: \(place.coordinate.latitude) y: \(place.coordinate.longitude)")
        let xcamera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 10)
        mapView.camera = xcamera
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
}


//extension UIImage {
//
//    func addText(_ drawText: NSString, atPoint: CGPoint, textColor: UIColor?, textFont: UIFont?) -> UIImage {
//
//        // Setup the font specific variables
//        var _textColor: UIColor
//        if textColor == nil {
//            _textColor = UIColor.white
//        } else {
//            _textColor = textColor!
//        }
//
//        var _textFont: UIFont
//        if textFont == nil {
//            _textFont = UIFont.systemFont(ofSize: 16)
//        } else {
//            _textFont = textFont!
//        }
//
//        // Setup the image context using the passed image
//        UIGraphicsBeginImageContextWithOptions(size, false, scale)
//
//        // Setup the font attributes that will be later used to dictate how the text should be drawn
//        let textFontAttributes = [
//            NSFontAttributeName: _textFont,
//            NSForegroundColorAttributeName: _textColor,
//            ] as [String : Any]
//
//        // Put the image into a rectangle as large as the original image
//        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
//
//        // Create a point within the space that is as bit as the image
//        let rect = CGRect(x: atPoint.x, y: atPoint.y, width: size.width, height: size.height)
//
//        // Draw the text into an image
//        drawText.draw(in: rect, withAttributes: textFontAttributes)
//
//        // Create a new image out of the images we have created
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//
//        // End the context now that we have the image we need
//        UIGraphicsEndImageContext()
//
//        //Pass the image back up to the caller
//        return newImage!
//
//    }
//
//}
