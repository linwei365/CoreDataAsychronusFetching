//
//  TableCheckViewController.swift
//  ResteurantPos
//
//  Created by Lin Wei on 3/7/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//

import UIKit
import CoreData

class TableCheckViewController: UIViewController , UITableViewDataSource, UITableViewDelegate,MenuItemTableViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
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
    
    
    //printer
    func showPrinterPicker () {
        //UIPrinterPickerController
        let printerPicker = UIPrinterPickerController (initiallySelectedPrinter: nil)
        //UIPrinterPickerController the modal is indicated
          
        printerPicker.presentAnimated(true, completionHandler: nil)
        
        
        
    }
    
    //tableview to pdf
    func pdfDataWithTableView (tableView:UITableView) ->NSData {
        let priorBounds:CGRect = tableView.bounds
        let fittedSize:CGSize = tableView.sizeThatFits(CGSize(width: priorBounds.size.width, height: priorBounds.size.height))
        tableView.bounds = CGRectMake(0, 0, fittedSize.width, fittedSize.height)
        
        // Standard US Letter dimensions 8.5" x 11"
        let pdfPageBounds:CGRect = CGRectMake(0, 0, 612, 792);
        let pdfData:NSMutableData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil)
        
        
        for(var pageOriginY:CGFloat = 0; pageOriginY < fittedSize.height; pageOriginY += pdfPageBounds.size.height){
            
            CGContextSaveGState(UIGraphicsGetCurrentContext())
            
            CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, -pageOriginY)
            
            tableView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
            
            CGContextRestoreGState(UIGraphicsGetCurrentContext())
            
        }
        
        UIGraphicsEndImageContext()
        tableView.bounds = priorBounds
        return pdfData
        
    }
    
    
    //works but not really well
    func imageWithTableView (tableView:UITableView) ->UIImage{
        
        let renderedView:UIView = tableView
        let tableContentOffset:CGPoint = tableView.contentOffset
        
        UIGraphicsBeginImageContextWithOptions(renderedView.bounds.size, renderedView.opaque, 0.0)
        let contextRef:CGContextRef = UIGraphicsGetCurrentContext()!
         CGContextTranslateCTM(contextRef, 0, -tableContentOffset.y)
        tableView.layer.renderInContext(contextRef)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        
        UIGraphicsEndImageContext();
        return image;
    }
    
    
    
 
    
    
    
    
    @IBAction func printOnClick(sender: UIButton) {
        
     
            
//             showPrinterPicker()
        
 
    let printController =  UIPrintInteractionController.sharedPrintController()
    let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.outputType = UIPrintInfoOutputType.General
        printInfo.jobName = "print job"
        printController.printInfo = printInfo
        
//    let printFormatter = UIMarkupTextPrintFormatter(markupText: "some text")
//        printFormatter.contentInsets = UIEdgeInsets(top: 72, left: 72, bottom: 72, right: 72)
//        printController.printFormatter = printFormatter
        
        //printController.printingItem = imageData
        
        //tableview to pdf
        //printController.printingItem = imageData
        
//        self.imageWithTableView(tableView)
         let imageData: NSData = UIImagePNGRepresentation(self.imageWithTableView(tableView))!
       
        printController.printingItem =  imageData
        
        
        
        printController.presentAnimated(true, completionHandler: nil)
        
        
        
       
        
        
        
    }
    
    @IBAction func payOnClick(sender: UIButton) {
        
    }
    
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
    
      func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 5
        
        
    }
    
      func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
      func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> (String!) {
        
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
    
    
      func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dineInTableCell", forIndexPath: indexPath)
        
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
      func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        
        table = tables[index!]
        
        //convert  set to array
        var tickets =  table!.ticket?.allObjects as! [Ticket]
        
        
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
