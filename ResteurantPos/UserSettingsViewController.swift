//
//  UserSettingsViewController.swift
//  ResteurantPos
//
//  Created by Lin Wei on 2/25/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//

import UIKit

class UserSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func printersOnClick(sender: UIButton) {
        
        //UIPrinterPickerController
        let printerPicker = UIPrinterPickerController (initiallySelectedPrinter: nil)
        //UIPrinterPickerController the modal is indicated
        
        
        printerPicker.presentAnimated(true, completionHandler: nil)
    }

    @IBAction func logOutOnClick(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
