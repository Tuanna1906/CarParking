//
//  ViewMapController.swift
//  CarParking
//
//  Created by Bonz on 6/27/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit
import SideMenu
import GoogleMaps
import GooglePlaces

class ViewMapController: UIViewController {

    //========== IBOutlet ====================================================
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var customViewInfo: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSideMenu()
        let camera = GMSCameraPosition.camera(withLatitude: 21.025817, longitude: 105.851701, zoom: 10)
        mapView.camera = camera
        
        dropShadow(customViewInfo)
        
    }
    
    fileprivate func setupSideMenu(){
        // Define the menus
        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the view controller it displays!
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        //Style
        SideMenuManager.menuPresentMode = .menuSlideIn
        //SideMenuManager.menuBlurEffectStyle = .dark
        SideMenuManager.menuAnimationFadeStrength = 0.1
        SideMenuManager.menuAnimationTransformScaleFactor = 0.950
        SideMenuManager.menuFadeStatusBar = false

    }
    
    //========== IBAction ====================================================
    @IBAction func clickBtnSearch(_ sender: Any) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)

    }
    
    @IBAction func clickBtnSelect(_ sender: UIButton) {
        sender.pulsate()
    }
    
    //========== Function ====================================================
    func dropShadow(_ view: UIView) {
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 10
        view.layer.masksToBounds = false
        
        
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        //view.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        //self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension ViewMapController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress!)")
        //print("Place attributions: \(place.attributions!)")
        print("Place x: \(place.coordinate.latitude) y: \(place.coordinate.longitude)")
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
