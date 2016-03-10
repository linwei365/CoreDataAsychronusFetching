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
    var priceB:String?
    var totalPrice:String?
   var index:Int?
    var takeoutChecks = [TakeOutCheck]()
    var takeoutCheck:TakeOutCheck? 
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
        
        do {
            takeoutChecks = try managedObjectContext.executeFetchRequest(fetchRequest) as! [TakeOutCheck]
            
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
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 1
        if section == 0 {
            rowCount = 1
        }
        if section == 1 {
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
        if (section == 0) {
            
            
            rowText = "                               takeout"
            
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
