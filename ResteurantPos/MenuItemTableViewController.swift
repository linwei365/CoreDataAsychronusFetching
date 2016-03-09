//
//  MenuItemTableViewController.swift
//  ResteurantPos
//
//  Created by Lin Wei on 3/3/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD

protocol MenuItemTableViewControllerDelegate {
    
    func update()
}

class MenuItemTableViewController: UITableViewController,UISearchBarDelegate {

    var delegate:MenuItemTableViewControllerDelegate?
    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var dishes = [Dish]()
    var filteredDish = [Dish]()
    var tables = [Table]()
    var firstname = String()
    var lastname = String()
    var tableNumber = String()
    var index:Int?
    private var myProgressObserverContext = 0
    
    var viewControllerIndex:Int?
    
    
    
    
    var searchText: String?
    var lastSelectedIndexPath: NSIndexPath?
    
    lazy   var searchBar:UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 0, 0))
    var searchActive : Bool = false
    
    //search ---
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    
    // searchbar delegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchText = searchText
        
        
        loadDataFilter()
        
    }
    
    //Progress Reporting
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let text = "fetching data count \(change!["new"]!)"
        SVProgressHUD.setStatus(text)
    }
    
    
    @IBAction func sendOnClick(sender: UIBarButtonItem) {
        
        
        
        if (viewControllerIndex == 1){
            
            let fetchRequest = NSFetchRequest(entityName: "Table")
            
            tables = try! managedObjectContext.executeFetchRequest(fetchRequest) as! [Table]
            
            
            let ticket = NSEntityDescription.insertNewObjectForEntityForName("Ticket", inManagedObjectContext: managedObjectContext) as! Ticket
            
            let dishPrice = dishes[(lastSelectedIndexPath?.row)!].price
            ticket.item = dishes[(lastSelectedIndexPath?.row)!].name
            ticket.price = "\(round(Double(dishPrice!) * 100) / 100)"
            ticket.tableNumber = tableNumber
            ticket.employeeFirstname = firstname
            ticket.employeeLastname = lastname
            
            
            //creates relationship with table
            ticket.table = tables[index!]
            
            
            do {
                try  managedObjectContext.save()
                
                navigationController?.popViewControllerAnimated(true)
                delegate?.update()
            }
                
            catch{
                
                print("failed to save item")
                return
            }
            
        } else if (viewControllerIndex == 2) {
            
            let fetchRequest = NSFetchRequest(entityName: "Table")
            tables = try! managedObjectContext.executeFetchRequest(fetchRequest) as! [Table]
            
            
            let ticket = NSEntityDescription.insertNewObjectForEntityForName("Ticket", inManagedObjectContext: managedObjectContext) as! Ticket
            
            let dishPrice = dishes[(lastSelectedIndexPath?.row)!].price
            ticket.item = dishes[(lastSelectedIndexPath?.row)!].name
            ticket.price = "\(round(Double(dishPrice!) * 100) / 100)"
//            ticket.tableNumber = tableNumber
            ticket.employeeFirstname = firstname
            ticket.employeeLastname = lastname
            
            
            //creates relationship with table
            ticket.table = tables[index!]
            
            
            do {
                try  managedObjectContext.save()
                
                navigationController?.popViewControllerAnimated(true)
                delegate?.update()
            }
                
            catch{
                
                print("failed to save item")
                return
            }
            
        }
  
 
       
        
        
        
    }
    
    //load from filter
    func loadDataFilter(){
        
        
        // cocaopods SVProgressHUD class method show indidicator with string
        /*
        dispatch_async(dispatch_get_main_queue(), {
        SVProgressHUD.showWithStatus("fetching Data", maskType: SVProgressHUDMaskType.Gradient)
        })
        */
        
        // fetchRequest
        let fetchRequest =  NSFetchRequest(entityName: "Dish")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        if (self.searchText != nil) {
            
            fetchRequest.predicate = NSPredicate(format: "name LIKE[c]'\(self.searchText!)*'")
        }
        
        
        
        
        //NSAsynchronousFetchRequest
        let async = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result:NSAsynchronousFetchResult) -> Void in
            
            self.filteredDish = result.finalResult as! [Dish]
            //Remove Observer
            result.progress?.removeObserver(self, forKeyPath: "completedUnitCount", context: &self.myProgressObserverContext)
            
            //dismiss indicator
            //        SVProgressHUD.dismiss()
            self.tableView.reloadData()
            
        }
        
        //perform block
        self.managedObjectContext.performBlock { () -> Void in
            
            //create NSProgress
            let progress: NSProgress = NSProgress(totalUnitCount: 1)
            
            //become current
            progress.becomeCurrentWithPendingUnitCount(1)
            
            // create NSError
            var asynchronousFetchRequestError: NSError?
            
            do {
                
                //NSAsynchronousFetchResult
                let result =  try self.managedObjectContext.executeRequest(async)  as! NSAsynchronousFetchResult
                
                //add observer
                result.progress?.addObserver(self, forKeyPath: "completedUnitCount", options: .New, context: &self.myProgressObserverContext)
            }
                
            catch let error1 as NSError {
                //catch error
                asynchronousFetchRequestError = error1
            }
            
            if asynchronousFetchRequestError != nil {
                print("failed")
            }
            //resigin NSProgress
            progress.resignCurrent()
        }
        
        
        if(filteredDish.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        
    }
    
    
    
    
    
    
   //load data
    func loadData(){
        
        
        
        // cocaopods SVProgressHUD class method show indidicator with string
        dispatch_async(dispatch_get_main_queue(), {
            // code here
            
            
            SVProgressHUD.showWithStatus("fetching Data", maskType: SVProgressHUDMaskType.Gradient)
        })
        
        
        
        // fetchRequest
        let fetchRequest =  NSFetchRequest(entityName: "Dish")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        //        if (self.searchText != nil)
        //
        //        {
        //            //        fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@",self.searchText!)
        //
        //            fetchRequest.predicate = NSPredicate(format: "name LIKE[c]'\(self.searchText!)*'")
        //        }
        
        //NSAsynchronousFetchRequest
        let async = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result:NSAsynchronousFetchResult) -> Void in
            
            self.dishes = result.finalResult as! [Dish]
            //Remove Observer
            result.progress?.removeObserver(self, forKeyPath: "completedUnitCount", context: &self.myProgressObserverContext)
            
            //dismiss indicator
            SVProgressHUD.dismiss()
            self.tableView.reloadData()
            
        }
        
        //perform block
        self.managedObjectContext.performBlock { () -> Void in
            
            //create NSProgress
            let progress: NSProgress = NSProgress(totalUnitCount: 1)
            
            //become current
            progress.becomeCurrentWithPendingUnitCount(1)
            
            // create NSError
            var asynchronousFetchRequestError: NSError?
            
            do {
                
                //NSAsynchronousFetchResult
                let result =  try self.managedObjectContext.executeRequest(async)  as! NSAsynchronousFetchResult
                
                //add observer
                result.progress?.addObserver(self, forKeyPath: "completedUnitCount", options: .New, context: &self.myProgressObserverContext)
            }
                
            catch let error1 as NSError {
                //catch error
                asynchronousFetchRequestError = error1
            }
            
            if asynchronousFetchRequestError != nil {
                print("failed")
            }
            //resigin NSProgress
            progress.resignCurrent()
        }
        
        
    }
    
    //put searchBar in navigationBar
    func loadSearchBar(){
        
        searchBar.delegate = self
        searchBar.placeholder = "Search Menu"
        //        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.titleView = searchBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        loadSearchBar()
        loadDataFilter()
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            //           self.populateDummyData()
            
            self.loadData()
            
            
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
        
        
        
        self.tableView.rowHeight = 60
        
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
        if (searchActive && searchBar.text != ""){
            
            return filteredDish.count
        }
        
        return dishes.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuItemCell", forIndexPath: indexPath)

       
         var dish :Dish!
        //use NSFetchedResultsController
        //dish = fetchResultController.objectAtIndexPath(indexPath) as! Dish
        
        if (searchActive && searchBar.text != nil){
            
            dish = filteredDish[indexPath.row]
        }
        else { dish = dishes[indexPath.row]
        }
        
        
        
        cell.textLabel?.text = dish.name! + "     $" + "\(round(Double(dish.price!) * 100) / 100)"
        cell.detailTextLabel?.text = dish.dishDescription!
        
        cell.imageView?.image = UIImage (data: (dish.dishPhoto)!)
        
        cell.accessoryType = (lastSelectedIndexPath?.row == indexPath.row) ? .Checkmark : .None
        
        return cell
    }
 
 
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row != lastSelectedIndexPath?.row {
            if let lastSelectedIndexPath = lastSelectedIndexPath {
                let oldCell = tableView.cellForRowAtIndexPath(lastSelectedIndexPath)
                oldCell?.accessoryType = .None
            }
            
            let newCell = tableView.cellForRowAtIndexPath(indexPath)
            newCell?.accessoryType = .Checkmark
            
            lastSelectedIndexPath = indexPath
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        
        
        
        
    }
    

}
