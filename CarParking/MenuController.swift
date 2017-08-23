//
//  MenuController.swift
//  CarParking
//
//  Created by Bonz on 7/20/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit
import SwiftyJSON

class MenuController: UIViewController {

    var viewMap: ViewMapController!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickBtnProfile(_ sender: UIButton) {
        nextScreen("ProfileScreen")
    }
    
    @IBAction func clickBtnHistory(_ sender: UIButton) {
        nextScreen("HistoryScreen")
    }

    @IBAction func clickBtnManagerCar(_ sender: UIButton) {
        nextScreen("ManagerCarScreen")
    }
    
    @IBAction func clickBtnLogout(_ sender: UIButton) {
        SocketIOManager.sharedInstance.socket.emit(Constants.Account.REQUEST_LOG_OUT, Instances.sharedInstance.accountID)
        SocketIOManager.sharedInstance.socket.on(Constants.Account.RESPONSE_LOG_OUT, callback: { (data, ask) in
            
            let json = JSON(data)[0]
            if json["result"].boolValue == true {
                self.resetInstances()
                self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
            }
            
            
            
            SocketIOManager.sharedInstance.socket.off(Constants.Account.RESPONSE_LOG_OUT)
        })

        //self.dismiss(animated: true, completion: nil)
    }
    
    func resetInstances() {
        Instances.sharedInstance.accountID = -1
        Instances.sharedInstance.role = 0
        Instances.sharedInstance.selectedGarageID = -1
        Instances.sharedInstance.garageID = -1
        UserDefaults.standard.set("", forKey: "tokenLogin")
    }
    
    func nextScreen(_ screen: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: screen) // MySecondSecreen the storyboard ID
        self.present(vc, animated: true, completion: nil)
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
