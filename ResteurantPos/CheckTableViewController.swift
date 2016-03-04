//
//  CheckTableViewController.swift
//  ResteurantPos
//
//  Created by Lin Wei on 2/25/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//

import UIKit
import CoreData

class CheckTableViewController: UITableViewController,MenuItemTableViewControllerDelegate {

    var firstname = String()
    var lastname = String()
    var tableNumber = String()
    var tableNumberB = String()
    var priceB = String()
    var tickets = [Ticket]()
    var totalPrice = String()
    
    
    
    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    func update() {
        loadData()
        tableView.reloadData()
    }
    
    func loadData(){
        
        let fetchRequest = NSFetchRequest(entityName: "Ticket")
        
        do {
           tickets = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Ticket]
            
        } catch{
            print("failed to get data from  Ticket")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        
        
    }

    @IBAction func cancelOnClick(sender: UIBarButtonItem) {
        
        navigationController?.popViewControllerAnimated(true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
       
        return 5
    
    
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        var rowCount = 1
        if section == 0 {
            rowCount = 1
        }
        if section == 1 {
            rowCount =  tickets.count
        }
        else {
            rowCount = 0
        }
        
        return rowCount
   
        
        
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> (String!) {
       
         var rowText = ""
        if (section == 0) {
           
            
            rowText = "                              Table # \(tableNumberB)"
            
        }
        if (section == 1){
            rowText = ""
        }
        
        if (section == 2)
        {
           rowText = "                                                Subtotal: \(priceB)"
        }
        if (section == 3) {
            rowText = "                                               Tax: 10%"
        }
        if (section == 4) {
            rowText = "                                               Total: \(totalPrice)"
        }
        
        
        return rowText
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("checkCell", forIndexPath: indexPath)

        // Configure the cell...
        
        if (tickets[indexPath.row].tableNumber != nil) {
        tableNumberB = tickets[indexPath.row].tableNumber!
            var value = Double()
            
           
        
            for ticket in tickets {
      
                 value += (round(Double(ticket.price!)! * 100) / 100)
            }
             priceB = "\(value)"
            totalPrice = "\(value * 0.1 + value)"
            
        cell.textLabel?.text = tickets[indexPath.row].item!
        cell.detailTextLabel?.text = tickets[indexPath.row].price!
            
            
        }

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
       
        
        
        let manageObject =  tickets[indexPath.row]
        
        tickets.removeAtIndex(indexPath.row)
        managedObjectContext.deleteObject(manageObject)
        
        do {
            try managedObjectContext.save()
            
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
        
        
        let vc = segue.destinationViewController as! MenuItemTableViewController
        vc.lastname = lastname
        vc.firstname = firstname
        vc.tableNumber = tableNumber
        vc.delegate = self
        
        
    }


}
