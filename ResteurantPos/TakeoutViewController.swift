//
//  TakeoutViewController.swift
//  ResteurantPos
//
//  Created by Lin Wei on 3/7/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//

import UIKit
import CoreData
class TakeoutViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,MenuItemTableViewControllerDelegate {
    var priceB = String()
    var totalPrice = String()
   var index:Int?
    var takeoutChecks = [TakeOutCheck]()
    var takeoutCheck:TakeOutCheck?
    var ticketInfos = [TicketInfo]()
    var serverName = ""
     var orderTimer = ""
    @IBOutlet weak var tableView: UITableView!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext


    
    
    
    // new covert to image with all content
    
    func imageFromTableView (view:UITableView) ->UIImage {
        
        // tempframe to reset view size after image was created
        let tempFrame:CGRect  = view.frame
        var aFrame:CGRect = view.frame
        
        // set new Frame
        aFrame.size.height = view.sizeThatFits(UIScreen.mainScreen().bounds.size).height
        view.frame = aFrame
        //do image convert
        
        UIGraphicsBeginImageContext(view.sizeThatFits(UIScreen.mainScreen().bounds.size))
        let resizedContext:CGContextRef = UIGraphicsGetCurrentContext()!
        view.layer.renderInContext(resizedContext)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        
        // reset Frame of view to origin
        view.frame = tempFrame
        
        return image
        
    }
    
    
    
    
    
    @IBAction func printOnClick(sender: UIButton) {
        
        
        
        //             showPrinterPicker()
        
        
        let printController =  UIPrintInteractionController.sharedPrintController()
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.outputType = UIPrintInfoOutputType.General
        printInfo.jobName = "print job"
        printInfo.orientation = UIPrintInfoOrientation.Portrait
        
        printController.printInfo = printInfo
        
        //    let printFormatter = UIMarkupTextPrintFormatter(markupText: "some text")
        //        printFormatter.contentInsets = UIEdgeInsets(top: 72, left: 72, bottom: 72, right: 72)
        //        printController.printFormatter = printFormatter
        
        //printController.printingItem = imageData
        
        //tableview to pdf
        //printController.printingItem = imageData
        
        //        self.imageWithTableView(tableView)
        let imageData: NSData = UIImagePNGRepresentation(self.imageFromTableView(tableView))!
        
        
        printController.printingItem =  imageData
        
        
        
        printController.presentAnimated(true, completionHandler: nil)
        
        
        
        
        
        
        
    }
    
    @IBAction func payOnClick(sender: UIButton) {
        
    }
    
    
    
    
    
    
    func loadData(){
        
        let fetchRequest = NSFetchRequest(entityName: "TakeOutCheck")
        let fetchRequestB =  NSFetchRequest(entityName: "TicketInfo")
        
        do {
            takeoutChecks = try managedObjectContext.executeFetchRequest(fetchRequest) as! [TakeOutCheck]
            ticketInfos = try managedObjectContext.executeFetchRequest(fetchRequestB) as! [TicketInfo]
            
            takeoutCheck = takeoutChecks[index!]
            
        } catch{
            print("failed to get data from  takeoutCheck")
        }
        
    }
    
    
    
    func update() {
        loadData()
        
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

         loadData()
         // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
      func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 10
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 1
        if section == 0 {
            rowCount = 1
        }
        if section == 6 {
            // Configure the cell...
            
            
            
            //convert  set to array
             let tickets =  takeoutCheck!.ticket?.allObjects as! [Ticket]
            
            rowCount =  tickets.count
        }
        else {
            rowCount = 0
        }
        
        return rowCount
        
        
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> (String!) {
        
        var rowText = ""
        
        if (ticketInfos.count == 0){
            
            if (section == 0) {
                rowText = "                               Company Name"
                
            }
            if (section == 1){
                rowText = "Company  Street Address"
            }
            
            if (section == 2)
            {
                rowText = "Company State City Zip code"
            }
            if (section == 3) {
                rowText = "Company Phone number"
            }
            if (section == 4) {
                rowText = "Time: \(orderTimer)"
            }
            if (section == 5) {
                rowText = "Server:\(serverName) "
            }
            if (section == 6) {
                rowText = "Order Number#:  "
            }
            if (section == 7) {
                
                rowText = "Tax: 10% "
            }
            if (section == 8) {
                rowText = "Gratuity:  "
            }
            if (section == 9) {
                rowText = "Total: \(totalPrice)"
            }

        } else if (ticketInfos.count == 1 ){
            
            if (section == 0) {
                rowText = "                               \(ticketInfos[0].companyName!)"
                
            }
            if (section == 1){
                rowText = "\(ticketInfos[0].companyStreetAddress!)"
            }
            
            if (section == 2)
            {
                rowText = "\(ticketInfos[0].companyCity!) \(ticketInfos[0].companyState!) \(ticketInfos[0].compnayZip!)"
            }
            if (section == 3) {
                rowText = "\(ticketInfos[0].compnayPhoneNumber!)"
            }
            if (section == 4) {
                rowText = "Time: \(orderTimer) "
            }
            if (section == 5) {
                rowText = "Server: \(serverName) "
            }
            if (section == 6) {
                rowText = "Order Number#:  "
            }
            if (section == 7) {
                
                rowText = "Tax: \(ticketInfos[0].tax!) "
            }
            if (section == 8) {
                rowText = "Gratuity: \(ticketInfos[0].gratuity!) "
            }
            if (section == 9) {
                rowText = "Total: \(totalPrice)"
            }

        }
        
        
        
        return rowText
        
    }
    
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCellWithIdentifier("takeoutCell", forIndexPath: indexPath)
        
        let tickets = takeoutCheck!.ticket?.allObjects as! [Ticket]
        
        cell.textLabel?.text = tickets[indexPath.row].item
        cell.detailTextLabel?.text = tickets[indexPath.row].price
        
        
        
        var value = Double()
        
        for ticket in tickets {
            
            value += (round(Double(ticket.price!)! * 100) / 100)
        }
        priceB = "\(value)"
        totalPrice = "\(value * 0.1 + value)"
        
        return cell
    }
    
    

    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        
        takeoutCheck = takeoutChecks[index!]
        
        //convert  set to array
        var tickets =  takeoutCheck!.ticket?.allObjects as! [Ticket]
        
        
        //after swaped line 197 198 worked :D
        
        managedObjectContext.deleteObject(tickets[indexPath.row])
        tickets.removeAtIndex(indexPath.row )
        

        
        do {
            try managedObjectContext.save()
            
        }
        catch {
            print("failed to save ")
            
            return
        }
        self.tableView.reloadData()
        
   
    }
    

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let vc =  segue.destinationViewController as! MenuItemTableViewController
        
        vc.delegate = self
        vc.index = index
        vc.viewControllerIndex = 2
    }
   

}
