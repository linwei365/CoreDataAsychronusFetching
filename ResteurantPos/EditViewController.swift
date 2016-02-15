//
//  EditViewController.swift
//  ResteurantPos
//
//  Created by Lin Wei on 2/15/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//

import UIKit
import CoreData

class EditViewController: UIViewController {

    var dishes = [Dish]()
    var managedObjectContext:NSManagedObjectContext?
    
    
    @IBOutlet weak var dishNameTextField: UITextField!
    @IBOutlet weak var dishPriceTextField: UITextField!
    @IBOutlet weak var dishDescriptionTextField: UITextField!
    
    @IBOutlet weak var dishImageView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelOnClick(sender: UIBarButtonItem) {
    }

    @IBAction func saveOnClick(sender: UIBarButtonItem) {
    }
    @IBAction func photoLibraryOnClick(sender: AnyObject) {
    }
    
    @IBAction func takeAPhotoOnClick(sender: UIButton) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
