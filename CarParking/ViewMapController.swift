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

    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSideMenu()
        let camera = GMSCameraPosition.camera(withLatitude: 21.025817, longitude: 105.851701, zoom: 10)
        mapView.camera = camera
        
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
    
    @IBAction func clickBtnSearch(_ sender: Any) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)

    }
    
    @IBAction func clickBtnSelect(_ sender: UIButton) {
        sender.pulsate()
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
