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
    
    var firstname = String()
    var lastname = String()
    var tableNumber = String()
    
    //load data
    func loadData () {
        let fetchRequest = NSFetchRequest(entityName: "Table")
        
  
        
        var error: NSError?
        do {
            
            tables = try moc.executeFetchRequest(fetchRequest) as! [Table]
            
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tables.count
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableNumberCell", forIndexPath: indexPath)
        
       
        tableNumber = tables[indexPath.row].tableNumber!
        
        firstname = (tables[indexPath.row].employee?.employeeFirstname)!
        lastname = (tables[indexPath.row].employee?.empolyeeLastname)!

        
        cell.textLabel?.text = "Table # " + tableNumber
       
         let pin =  (tables[indexPath.row].employee?.employeePinNumber)!
        
        
        
        print(pin)
        cell.detailTextLabel?.text = "Employee Name: " + firstname + " " + lastname
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

  
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
        let vc = segue.destinationViewController as! TableCheckViewController
        
            vc.lastname = lastname
            vc.firstname = firstname
            vc.tableNumber = tableNumber
        
            vc.index = tableView.indexPathForSelectedRow?.row
   
         
     
    }
    

}
