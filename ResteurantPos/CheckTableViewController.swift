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
    var tables = [Table]()
    var totalPrice = String()
    var index:Int?
    var ticketArray = []
    var table:Table?
    
    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    func update() {
        loadData()
        
      
        tableView.reloadData()
    }
    
    func loadData(){
        
        let fetchRequest = NSFetchRequest(entityName: "Table")
        
        do {
           tables = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Table]
            
              table = tables[index!]
            
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

    func dissmissVC(){
        
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func cancelOnClick(sender: UIBarButtonItem) {
        
        dissmissVC()
        //optional jump to different controller
//        navigationController?.popViewControllerAnimated(true)
        
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
            // Configure the cell...
            
          
            
            //convert  set to array
            let tickets =  table!.ticket?.allObjects as! [Ticket]
            
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
        
          table = tables[index!]
        
        print("index \(index!)")
        
        //convert  set to array
        let tickets =  table!.ticket?.allObjects as! [Ticket]
        
        tableNumberB = tickets[indexPath.row].tableNumber!
        
          cell.textLabel?.text = tickets[indexPath.row].item!
        
         var value = Double()
        
        for ticket in tickets {
            
                             value += (round(Double(ticket.price!)! * 100) / 100)
                        }
                         priceB = "\(value)"
                        totalPrice = "\(value * 0.1 + value)"

         cell.detailTextLabel?.text = tickets[indexPath.row].price!
        
 

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
       
        
        
       
        table = tables[index!]
        
        //convert  set to array
        var tickets =  table!.ticket?.allObjects as! [Ticket]
        
        tickets.removeAtIndex(indexPath.row)
     
        managedObjectContext.deleteObject(tickets[indexPath.row])
        
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
        vc.index = index
        
        
    }


}
