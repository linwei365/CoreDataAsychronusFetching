//
//  EditViewController.swift
//  ResteurantPos
//
//  Created by Lin Wei on 2/15/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//

import UIKit
import CoreData

class EditViewController: UIViewController,NSFetchedResultsControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    var dish:Dish?
    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    @IBOutlet weak var dishNameTextField: UITextField!
    @IBOutlet weak var dishPriceTextField: UITextField!
    @IBOutlet weak var dishDescriptionTextField: UITextField!
    
    @IBOutlet weak var dishImageView: UIImageView!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if dish != nil {
            
            dishNameTextField.text =  dish?.name
            dishPriceTextField.text =     "\(Double(dish!.price!))"
            dishDescriptionTextField.text = dish?.dishDescription
            dishImageView.image = UIImage(data: (dish?.dishPhoto)!)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func loadData () {
//        
//        let fetchReqest =  NSFetchRequest(entityName: "Dish")
//        
//        try! dishes = managedObjectContext.executeFetchRequest(fetchReqest) as! [Dish]
//    
//        
//    }
    
    
    func createNewItem(){
        
      
        
          dish =  NSEntityDescription.insertNewObjectForEntityForName("Dish", inManagedObjectContext: managedObjectContext) as? Dish
        
       dish!.setValue(self.dishNameTextField.text, forKey: "name")
        
        dish!.price = Double(self.dishPriceTextField.text!)
       
        dish!.dishDescription = self.dishDescriptionTextField.text
        
        dish!.dishPhoto = UIImagePNGRepresentation(self.dishImageView.image!)
       
        var error:NSError?
        do {
            try managedObjectContext.save()
           
            
        } catch let error1 as NSError {
            
            error =  error1
            
        }
        if error != nil {
            print("failed to save Data")
        }
        
        
    }
    
    
    func editItem(){
        
        
        
     
        
        dish!.setValue(self.dishNameTextField.text, forKey: "name")
             dish!.price = Double(self.dishPriceTextField.text!)
        dish!.dishDescription = self.dishDescriptionTextField.text
        
        
        dish!.dishPhoto = UIImagePNGRepresentation(self.dishImageView.image!)
        
        var error:NSError?
        do {
            try managedObjectContext.save()
        
            
        } catch let error1 as NSError {
            
            error =  error1
            
        }
        if error != nil {
            print("failed to save Data")
        }
        
        
    }
 
    
    @IBAction func cancelOnClick(sender: UIBarButtonItem) {
    
        dissmissVC()
    
    }

    @IBAction func saveOnClick(sender: UIBarButtonItem) {
        
        
        if dish != nil {
            
            editItem()
        } else {
            
            createNewItem()
        }
        
        
        
        dissmissVC()
    }
    @IBAction func photoLibraryOnClick(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        pickerController.allowsEditing = true
        
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func takeAPhotoOnClick(sender: UIButton) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        pickerController.allowsEditing = true
        
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    //set image to dishImage view when dismiss from the ImagePickerController
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        self.dishImageView.image = image
       
    }
    
    
    func dissmissVC(){
        
        navigationController?.popToRootViewControllerAnimated(true)
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
