//
//  UserSettingsViewController.swift
//  ResteurantPos
//
//  Created by Lin Wei on 2/25/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//

import UIKit
import CoreData



class UserSettingsViewController: UIViewController {

let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
  
//var employee = Employee()
    
    
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
    
    @IBAction func dineInOnClick(sender: UIButton) {
        
        let fetchRequest = NSFetchRequest(entityName: "Employee")
        
        let alertController = UIAlertController(title: "Pin Number", message: "Please enter your Pin Number", preferredStyle: .Alert)
        
        let alertActionA =  UIAlertAction(title: "Ok", style: .Default) { (action:UIAlertAction) -> Void in
            
            let pinNumber =  alertController.textFields![0]
            
           
  
            //check if textfile is empty if true alert to fill up the message
            
            if ((pinNumber.text?.isEmpty) == true ){
                
                let alertController =  UIAlertController(title: "Error", message: "please fill in all the blanks", preferredStyle: UIAlertControllerStyle.Alert)
                let alertAction =  UIAlertAction(title: "ok", style: .Default, handler: nil)
                alertController.addAction(alertAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
                
                
            }
            else {
                fetchRequest.predicate = NSPredicate(format: "employeePinNumber = %@", pinNumber.text!)
                
                let results:NSArray? =  try! self.moc.executeFetchRequest(fetchRequest)
                
                if results?.count == 0
                {
                    let alertController =  UIAlertController(title: "Error", message: "The Pin Number Is Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                    let alertAction =  UIAlertAction(title: "ok", style: .Default, handler: nil)
                    alertController.addAction(alertAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                    
           
                }
                    
                else
                {
                    let alertControllerTable =  UIAlertController(title: "Table Number", message: "Please Enter your Table Number", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    
                    let alertAction =  UIAlertAction(title: "Ok", style: .Default, handler: { (action:UIAlertAction) -> Void in
                       
                        let tableNumber = alertControllerTable.textFields![0]
                        
                        //check if the tableNumberText has input
                        
                        
                        //check if the tableNumberText already exsit
                        
                        
                        
                        
                    })
                   
                    let alertCancelAction =  UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action:UIAlertAction) -> Void in
                        
                        
                    })
                    
                    
                    alertControllerTable.addTextFieldWithConfigurationHandler { (tableNumber:UITextField) -> Void in
                        
                        tableNumber.placeholder = "Table Number"
                        
                        
                    }
                    
                    alertControllerTable.addAction(alertAction)
                    alertControllerTable.addAction(alertCancelAction)
                    self.presentViewController(alertControllerTable, animated: true, completion: nil)
             
                    
                             print("changing view")
                    
                    
                    
                    print("Error:")
                    
                }
                
                
                
                
            }
            
            
            
            
        }
        
        
        
        
        alertController.addTextFieldWithConfigurationHandler { (pinNumber:UITextField) -> Void in
            
            pinNumber.placeholder = "Pin Number"
            
            
        }
        
        
        let cancelAction =  UIAlertAction(title: "cancel", style: UIAlertActionStyle.Cancel) { (action:UIAlertAction) -> Void in
            
        }
        
        alertController.addAction(alertActionA)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
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
