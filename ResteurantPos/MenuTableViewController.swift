//
//  MenuTableViewController.swift
//  ResteurantPos
//
//  Created by Lin Wei on 2/15/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//

import UIKit
import CoreData


class MenuTableViewController: UITableViewController, NSFetchedResultsControllerDelegate,UISearchBarDelegate{
//step 2 array stores managed object which here is the Dish
    var dishes = [Dish]()
    var filteredDish = [Dish]()
    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var fetchResultController = NSFetchedResultsController()
    
    var filterFetchResultController = NSFetchedResultsController()
    
    
    var searchText: String?
    @IBOutlet weak var searchBar: UISearchBar!
    
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
    
//testing generating data
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
    

    func loadData(){
        
//    generateData()
        
      
        let fetchRequest =  NSFetchRequest(entityName: "Dish")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        let async = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result:NSAsynchronousFetchResult) -> Void in
       
            self.dishes = result.finalResult as! [Dish]
            
            self.tableView.reloadData()
         }
        
//        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
       
        var error :NSError?
        do {
            
//            try dishes =   managedObjectContext.executeFetchRequest(fetchRequest) as! [Dish]
//            try fetchResultController.performFetch()
            
//            managedObjectContext.performBlock({ () -> Void in
//                
//                
//            })
//            
//            
             try    managedObjectContext.executeRequest(async)
          
        }
      catch let error1 as NSError{
         error =  error1
        }
        if error != nil {
            print( "failed to load data")
        }
        
         
    }
    
 
    @IBAction func addButtonOnClick(sender: UIBarButtonItem) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//       generateData()
        
        
        self.tableView.rowHeight = 60
//        fetchResultController.delegate = self
//        filterFetchResultController.delegate = self
       
         self.tableView.reloadData()
    }
    
//    
//    func controllerDidChangeContent(controller: NSFetchedResultsController) {
//     
//        self.tableView.reloadData()
//    }
    
    override func viewWillAppear(animated: Bool) {
    
//        loadData()
        self.tableView.reloadData()
    }
  
    
    override func viewDidAppear(animated: Bool) {
       
        loadData()
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
    
        
        return 1
//        return (fetchResultController.sections?.count)!
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       
   
        return dishes.count
//        return fetchResultController.sections![section].numberOfObjects
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
 
        let dish :Dish
        
    
            
//              dish = fetchResultController.objectAtIndexPath(indexPath) as! Dish

        dish = dishes[indexPath.row]
        
        
        cell.textLabel?.text = dish.name! + "     $" + "\(Double(dish.price!))"
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
        
//        
//        let manageObject: NSManagedObject = fetchResultController.objectAtIndexPath(indexPath) as! NSManagedObject
//        
//        managedObjectContext.deleteObject(manageObject)
        
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
        
        if segue.identifier == "editSegue" {
            
            let vc =  segue.destinationViewController as! EditViewController
            
//            let index =  self.tableView.indexPathForCell(sender as! UITableViewCell)
            
     
                
//                vc.dish =  fetchResultController.objectAtIndexPath(index!) as? Dish
            
            let index =  self.tableView.indexPathForSelectedRow

            vc.dish = dishes[(index?.row)!]
  
            
            
        }
        
        
        
    }
    

}
