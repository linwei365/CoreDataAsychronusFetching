//
//  EmployeeTableViewController.swift
//  ResteurantPos
//
//  Created by Lin Wei on 3/2/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//

import UIKit
import CoreData

class EmployeeTableViewController: UITableViewController,EditEmployeeViewControllerDelegate {

  let moc =  (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
   var employees = [Employee]()
    
 
    var pinNumber = [String]()
   
    func passVaule() {
         tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
       
        
    }
    
    // save text function
    func saveText(firstName: String, lastName: String, pinNumber: String){
        
        let employee = NSEntityDescription.insertNewObjectForEntityForName("Employee", inManagedObjectContext: moc) as! Employee
        
        employee.employeeFirstname =  firstName
        employee.empolyeeLastname = lastName
        employee.employeePinNumber = pinNumber
   
        var error: NSError?
        
        do {
            
            
            try moc.save()
            loadData()
            self.tableView.reloadData()
      
        }
        catch let error1 as NSError {
            
            error =  error1
        }
        
        if error != nil {
            
            print("failed to save")
        }
        
        
    }
    

    
    
    //add new user
    
    @IBAction func addOnClick(sender: AnyObject) {
        let alert  =  UIAlertController(title: "Add Instructor", message: "New Instructor Name", preferredStyle: UIAlertControllerStyle.Alert)
        
        let addAction =  UIAlertAction(title: "add", style: UIAlertActionStyle.Default) { (action:UIAlertAction) -> Void in
            
                    let fetchRequest = NSFetchRequest(entityName: "Employee")
           
   
            
            let firstName = alert.textFields![0]
            let lastName = alert.textFields![1]
            let pinNumber = alert.textFields![2]
            
            //check if textfile is empty if true alert to fill up the message
            
            if ((firstName.text?.isEmpty) == true || (lastName.text?.isEmpty) == true || (pinNumber.text?.isEmpty) == true ){
                
                let alertController =  UIAlertController(title: "Error", message: "please fill in all the blanks", preferredStyle: UIAlertControllerStyle.Alert)
                let alertAction =  UIAlertAction(title: "ok", style: .Default, handler: nil)
                alertController.addAction(alertAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
              
                
            }
            else {
                 fetchRequest.predicate = NSPredicate(format: "employeePinNumber contains[c] %@", pinNumber.text!)
    
                let results:NSArray? =  try! self.moc.executeFetchRequest(fetchRequest)
                
                if results?.count == 0
                {
                     self.saveText(firstName.text!, lastName: lastName.text!, pinNumber: pinNumber.text!)
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
        
        
        
        let cancelAction =  UIAlertAction(title: "cancel", style: UIAlertActionStyle.Cancel) { (action:UIAlertAction) -> Void in
            
        }
        
        alert.addTextFieldWithConfigurationHandler { (firstName:UITextField) -> Void in
            
            firstName.placeholder = "First Name"
            
            
        }
        alert.addTextFieldWithConfigurationHandler { (lastName:UITextField) -> Void in
            
            lastName.placeholder = "Last Name"
            
            
        }
        alert.addTextFieldWithConfigurationHandler { (courseTitle:UITextField) -> Void in
         
            courseTitle.placeholder = "Pin Number"
            
            
            
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        
        
        presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    //load data
    func loadData () {
        let fetchRequest = NSFetchRequest(entityName: "Employee")

        var error: NSError?
        do {
            
            employees = try moc.executeFetchRequest(fetchRequest) as! [Employee]
            
        }
        catch let error1 as NSError {
            
            error = error1
                }

        if (error != nil){
            
            print("failed to load")
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        loadData()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return employees.count
    }

    @IBAction func cancelOnClick(sender: UIBarButtonItem) {
        navigationController!.popViewControllerAnimated(true)
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("employee", forIndexPath: indexPath)
        
        let employee = employees[indexPath.row]
        
        cell.textLabel?.text =  employee.employeeFirstname! + " " + employee.empolyeeLastname!
        cell.detailTextLabel?.text = "Pin Number: " + employee.employeePinNumber!
        
        
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

   
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let manageObject =  employees[indexPath.row]
        
        employees.removeAtIndex(indexPath.row)
        moc.deleteObject(manageObject)
        
        do {
            try moc.save()
            
        }
        catch {
            print("failed to save ")
            
            return
        }
        self.tableView.reloadData()
        
        
//        
//        if editingStyle == .Delete {
//            // Delete the row from the data source
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
         let  vc =  segue.destinationViewController as! EditEmployeeViewController
           vc.delegate = self
        
         
            let index =  self.tableView.indexPathForSelectedRow
        
            vc.employee = employees[(index?.row)!]
        
    }
    

}
