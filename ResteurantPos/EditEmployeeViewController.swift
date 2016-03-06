//
//  EditEmployeeViewController.swift
//  ResteurantPos
//
//  Created by Lin Wei on 3/2/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//

import UIKit
import CoreData

//adding protocol

protocol EditEmployeeViewControllerDelegate {
    
    func passVaule()
    
    
}

class EditEmployeeViewController: UIViewController {

    
    
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var pinNumberTextField: UITextField!
    
    var employee:Employee?
    let moc =  (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
   
    var delegate:EditEmployeeViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        firstnameTextField.text = employee!.employeeFirstname
        lastnameTextField.text = employee!.empolyeeLastname
        pinNumberTextField.text = employee!.employeePinNumber
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelOnClick(sender: AnyObject) {
        
      navigationController!.popViewControllerAnimated(true)
    }

    @IBAction func saveOnClick(sender: AnyObject) {
        
        
         let fetchRequest = NSFetchRequest(entityName: "Employee")
        
        
        if ((firstnameTextField.text?.isEmpty) == true || (lastnameTextField.text?.isEmpty) == true || (pinNumberTextField.text?.isEmpty) == true ){
            
            let alertController =  UIAlertController(title: "Error", message: "please fill in all the blanks", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction =  UIAlertAction(title: "ok", style: .Default, handler: nil)
            alertController.addAction(alertAction)
            self.presentViewController(alertController, animated: true, completion: nil)
             
        }
        else
        {   //if textfield pin is same as moc pinNumber then perform
            if ( pinNumberTextField.text == employee!.employeePinNumber ){
            
                
                employee!.employeeFirstname = firstnameTextField.text
                employee!.empolyeeLastname = lastnameTextField.text
                employee!.employeePinNumber = pinNumberTextField.text
                
                var error:NSError?
                
                do {
                    try moc.save()
                    navigationController!.popViewControllerAnimated(true)
                    
                    delegate?.passVaule()
                }
                catch  let error1 as NSError {
                    
                    error = error1
                }
                if error != nil {
                    print("failed to save")
                }
                
            }
            
            else {
                //else check if the database has the same pin if same pin pop alert is already taken
                
                fetchRequest.predicate = NSPredicate(format: "employeePinNumber contains[c] %@", pinNumberTextField.text!)
                
                let results:NSArray? =  try! self.moc.executeFetchRequest(fetchRequest)
                
                if results?.count == 0
                    
                {
                    employee!.employeeFirstname = firstnameTextField.text
                    employee!.empolyeeLastname = lastnameTextField.text
                    employee!.employeePinNumber = pinNumberTextField.text
                    
                    var error:NSError?
                    
                    do {
                        try moc.save()
                        navigationController!.popViewControllerAnimated(true)
                        
                        delegate?.passVaule()
                    }
                    catch  let error1 as NSError {
                        
                        error = error1
                    }
                    if error != nil {
                        print("failed to save")
                    }
                    
                    
                    
                }
                    
                    
                else
                {
                    
                    let alertController =  UIAlertController(title: "Error", message: "that pin is already taken please use a different Pin", preferredStyle: UIAlertControllerStyle.Alert)
                    let alertAction =  UIAlertAction(title: "ok", style: .Default, handler: nil)
                    alertController.addAction(alertAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                    
                    print("Error:")
                    
                }
                
            }
         
            
   
    
    
        }
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
