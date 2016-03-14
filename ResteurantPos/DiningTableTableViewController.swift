//
//  DiningTableTableViewController.swift
//  ResteurantPos
//
//  Created by Lin Wei on 3/3/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//

import UIKit
import CoreData
class DiningTableTableViewController: UITableViewController {

    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var tables = [Table]()
    var takeOutChecks = [TakeOutCheck]()
    var firstname = String()
    var lastname = String()
    var tableNumber = String()
    var orderNumber = String()
    var orderTimer = String()
    
    var indexpath:NSIndexPath?
    //load data
    func loadData () {
        let fetchRequest = NSFetchRequest(entityName: "Table")
        
        let fetchRequestB = NSFetchRequest(entityName: "TakeOutCheck")
        
        var error: NSError?
        do {
            
            tables = try moc.executeFetchRequest(fetchRequest) as! [Table]
            takeOutChecks = try moc.executeFetchRequest(fetchRequestB) as! [TakeOutCheck]
            
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
        
        loadData()
        
        tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        var count = 0
        if section == 0 {
            count = tables.count
            
        }
        else if (section == 1){
           count =  takeOutChecks.count
          
        }
        
        return count
       
        
        
        
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableNumberCell", forIndexPath: indexPath)
        
        
        if(indexPath.section == 0){
            tableNumber = tables[indexPath.row].tableNumber!
            
            firstname = (tables[indexPath.row].employee?.employeeFirstname)!
            lastname = (tables[indexPath.row].employee?.empolyeeLastname)!
//            orderTimer = (tables[indexPath.row].employee?.orderTime)!
            
            cell.textLabel?.text = "Table # " + tableNumber
            
            let pin =  (tables[indexPath.row].employee?.employeePinNumber)!
            
            
            
            print(pin)
            cell.detailTextLabel?.text = "Employee Name: " + firstname + " " + lastname
            
        } else if(indexPath.section == 1) {
            
            
            cell.textLabel?.text = "Employee Name: " + (takeOutChecks[indexPath.row].employee?.employeeFirstname)! + " " + (takeOutChecks[indexPath.row].employee?.empolyeeLastname)!
            
 
            
//            cell.textLabel?.text = "Table # " + takeOutChecks[indexPath.row].takeoutOrderNumber!
//            
//            let pin =  (tables[indexPath.row].employee?.employeePinNumber)!
//            
//            
//            
//            print(pin)
            
        }
            
            
        
        

        return cell
    }

    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> (String!) {
        
        var rowText = ""
        if (section == 0) {
            
            
            rowText = "                              Table Checks"
            
        }
        if (section == 1){
            rowText = "                              Take Out Checks"
        }
        
     
        
        return rowText
        
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

        if(indexPath.section == 0){
            let manageObject =  tables[indexPath.row]
            
            tables.removeAtIndex(indexPath.row)
            moc.deleteObject(manageObject)
            
            do {
                try moc.save()
                
            }
            catch {
                print("failed to save ")
                
                return
            }
           
        }
        else {
            let manageObject =  takeOutChecks[indexPath.row]
            
            takeOutChecks.removeAtIndex(indexPath.row)
            moc.deleteObject(manageObject)
            
            do {
                try moc.save()
                
            }
            catch {
                print("failed to save ")
                
                return
            }

            
            
        }
  
         self.tableView.reloadData()
        
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

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
            indexpath = indexPath
        
        if indexPath.section == 0 {
                    performSegueWithIdentifier("checksToTableCheckSegue", sender: self)
            
        }
        
        else
        {
             performSegueWithIdentifier("checksToTakeoutcheck", sender: self)
            
        }


    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
       
      
        
 
            
            if(segue.identifier == "checksToTableCheckSegue"){
                
                let vc = segue.destinationViewController as! TableCheckViewController
                
                vc.lastname = lastname
                vc.firstname = firstname
                vc.tableNumber = tableNumber
                
                vc.index = indexpath?.row
                print(vc.index)
                vc.tableNumberB = tableNumber
                vc.serverName = "\(firstname) \(lastname)"
                vc.orderTimer = orderTimer
             
         
            }
            else if (segue.identifier == "checksToTakeoutcheck"){
                
                
                  let vc = segue.destinationViewController as! TakeoutViewController
                
                vc.index = indexpath?.row
                 vc.serverName = "\(firstname) \(lastname)"
                vc.orderTimer = orderTimer
             
                
             
        }
       
   


    
            
 

        
        
            
        
     
    }
    

}
