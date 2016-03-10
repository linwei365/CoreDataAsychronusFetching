//
//  TakeoutViewController.swift
//  ResteurantPos
//
//  Created by Lin Wei on 3/7/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//

import UIKit

class TakeoutViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,MenuItemTableViewControllerDelegate {

   var index:Int?
    
    @IBOutlet weak var tableView: UITableView!
    
    func update() {
//        loadData()
        
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
//            let tickets =  table!.ticket?.allObjects as! [Ticket]
//            
//            rowCount =  tickets.count
        }
        else {
            rowCount = 0
        }
        
        return rowCount
        
        
    }
    
    
    
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCellWithIdentifier("takeoutCell", forIndexPath: indexPath)
        
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
