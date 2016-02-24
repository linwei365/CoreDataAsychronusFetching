//
//  MenuTableViewController.swift
//  ResteurantPos
//
//  Created by Lin Wei on 2/15/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD



class MenuTableViewController: UITableViewController, NSFetchedResultsControllerDelegate,UISearchBarDelegate,EditViewControllerDelegate{
//step 2 array stores managed object which here is the Dish
    var dishes = [Dish]()
    var filteredDish = [Dish]()
    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var fetchResultController = NSFetchedResultsController()
    
    var filterFetchResultController = NSFetchedResultsController()
    private var myProgressObserverContext = 0
 
    var searchText: String?
 
    
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
    

    
//testing generating data not in use
    func generateData(){
        
        for var index = 0; index < 20000; ++index {
            print("index is \(index)")
              let dish = NSEntityDescription.insertNewObjectForEntityForName("Dish", inManagedObjectContext: managedObjectContext) as!Dish
            dish.name = "delicious \(index)"
            dish.price = 9.95
            dish.dishDescription = "delicious meal \(index)"
            let image = UIImage(named: "images")
            dish.dishPhoto = UIImagePNGRepresentation(image!)
            
        }
        
      try! managedObjectContext.save()
        
        
        
    }
    
 
 
    func loadDataWithKVO (){
        
//        if (searchActive){
//            loadDataFilter()
//        }
//      
        
             loadData()
       
        
       

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
    
    //------- dumpy data
    
    func populateDummyData (){
      // Helpers
        let userDefault = NSUserDefaults.standardUserDefaults()
        if ((userDefault.objectForKey("didPopulateDatabase")) != nil){
            return}
        for var index = 0 ; index < 30000; index++ {
            
            print("index is \(index)")
            let dish = NSEntityDescription.insertNewObjectForEntityForName("Dish", inManagedObjectContext: managedObjectContext) as!Dish
            dish.name = "delicious \(index)"
            dish.price = 9.95
            dish.dishDescription = "delicious meal \(index)"
            let image = UIImage(named: "images")
            dish.dishPhoto = UIImagePNGRepresentation(image!)
            
        }
        
     try! managedObjectContext.save()
        userDefault.setBool(true, forKey: "didPopulateDatabase")
        
    }
    
    //load from filter
   func loadDataFilter(){
    
    
    // cocaopods SVProgressHUD class method show indidicator with string
//    SVProgressHUD.showWithStatus("fetching Data", maskType: SVProgressHUDMaskType.Gradient)
    
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
    
    
    //delegate
    func onClickFetchData() {
        loadData()
        self.tableView.reloadData()
    }
    
  //
    func loadData(){
        
      
        
        // cocaopods SVProgressHUD class method show indidicator with string
        SVProgressHUD.showWithStatus("fetching Data", maskType: SVProgressHUDMaskType.Gradient)
        
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
    
 
    @IBAction func addButtonOnClick(sender: UIBarButtonItem) {
        
    
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
       self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        
        //------
        
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
        
       //use fetchResultController delegate
       //fetchResultController.delegate = self
 
       
//         self.tableView.reloadData()
    }
    
    
    //use fetchResultController delegate method
    /*
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
     
        self.tableView.reloadData()
    }
    */
    
    override func viewWillAppear(animated: Bool) {
    
     searchBar.text = ""
        
        self.tableView.reloadData()
     
    }
  
    
    
    
    override func viewDidAppear(animated: Bool) {

 
        
//        if (dishes.count > dishes.count){
//        loadData()
//        
//        
//            self.tableView.reloadData()
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
    
        
        return 1
        //use fetchResultController
        //return (fetchResultController.sections?.count)!
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       
        
        
 
        if (searchActive && searchBar.text != ""){
            
             return filteredDish.count
        }
       
        return dishes.count
      
        
   
        
        //use fetchResultController
        //return fetchResultController.sections![section].numberOfObjects
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
 
        let dish :Dish
        
    
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
        
        
 
        
        
        // Configure the cell...

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

  
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //use NSFetchedResultsController
       /*
        let manageObject: NSManagedObject = fetchResultController.objectAtIndexPath(indexPath) as! NSManagedObject
        
        managedObjectContext.deleteObject(manageObject)
        
        try managedObjectContext.save()
        */
        
        let manageObject =  dishes[indexPath.row]
        
        dishes.removeAtIndex(indexPath.row)
        managedObjectContext.deleteObject(manageObject)
        
        do {
            try managedObjectContext.save()
            
        }
        catch {
            print("failed to save ")
            
            return
        }
        self.tableView.reloadData()

      
        /*
        if editingStyle == .Delete {
        // Delete the row from the data source
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        */
    }
   
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        
        
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        return indexPath
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

    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
 
        
        
        let vc =  segue.destinationViewController as! EditViewController
        
            vc.delgate = self
        
        if segue.identifier == "editSegue" {
            
    

            let index =  self.tableView.indexPathForSelectedRow
            
        
            
            if (searchActive && searchBar.text != ""){
                
                 vc.dish = filteredDish[(index?.row)!]
            }
            
          
            else {
            
            
            vc.dish = dishes[(index?.row)!]
  
            }
            
            
            //use nsfetchResultController
            /*
            let index =  self.tableView.indexPathForCell(sender as! UITableViewCell)
            vc.dish =  fetchResultController.objectAtIndexPath(index!) as? Dish
            */
            
        }
        
        
        
    }
    

}
