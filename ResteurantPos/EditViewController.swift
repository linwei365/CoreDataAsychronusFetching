//
//  EditViewController.swift
//  ResteurantPos
//
//  Created by Lin Wei on 2/15/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//

import UIKit
import CoreData

protocol EditViewControllerDelegate {
    
    func onClickFetchData ()
    
}

class EditViewController: UIViewController,NSFetchedResultsControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ScanViewControllerDelegate,UITextFieldDelegate{
    var text:String = ""
    var dish:Dish?
    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    @IBOutlet weak var dishNameTextField: UITextField!
    @IBOutlet weak var dishPriceTextField: UITextField!
    @IBOutlet weak var dishDescriptionTextField: UITextField!
    
    @IBOutlet weak var dishImageView: UIImageView!
   
    
    var delgate:EditViewControllerDelegate?
   //this is my delegate method
    func scanText(text: String) {
        
        self.text = text
        
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if  ( dishNameTextField.isFirstResponder()){
            
            if text != "" {
            
                dishNameTextField.text = text }
         
            
 
        }
        else if  ( dishPriceTextField.editing){
            
             if text != "" {
            dishPriceTextField.text = text
            }
        }
        else   if  ( dishDescriptionTextField.editing){
            if text != "" {
           
                dishDescriptionTextField.text = text
            }
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let toolBar = UIToolbar(frame: CGRectMake(0, 0, 310.0, 44.0))
        
        toolBar.tintColor = UIColor(red: 0.6, green: 0.6, blue: 0.64, alpha: 1)
        
        
        
 
        toolBar.translucent = false;
        toolBar.items = [UIBarButtonItem(title: "Scan", style: .Done, target: self, action: "scanOnClick"), UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)]
        
        
     
        // some more items could be added
        
        self.dishNameTextField.inputAccessoryView = toolBar
        self.dishPriceTextField.inputAccessoryView = toolBar
        self.dishDescriptionTextField.inputAccessoryView = toolBar

        // Do any additional setup after loading the view.
        
       
        if dish != nil {
            
            dishNameTextField.text =  dish?.name
            dishPriceTextField.text =  "\(round(Double(dish!.price!) * 100) / 100)"
            dishDescriptionTextField.text = dish?.dishDescription
            dishImageView.image = UIImage(data: (dish?.dishPhoto)!)
            
        }
        
    }
    
    func scanOnClick(){
//        
//      let vc = UIStoryboardSegue.init(identifier: "home", source: EditViewController, destination: ScanViewController)
//        
         self.performSegueWithIdentifier("scan" , sender: self)
//        
        print("click")
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    func createNewItem(){
        
      
        
        dish =  NSEntityDescription.insertNewObjectForEntityForName("Dish", inManagedObjectContext: managedObjectContext) as? Dish
        
       dish!.setValue(self.dishNameTextField.text, forKey: "name")
        
        if(Double(self.dishPriceTextField.text!) != nil ) {
            dish!.price = Double(self.dishPriceTextField.text!)
        }
        else
        {
            let alert = UIAlertController(title: "Alert", message: "\"Second text field\" must be a valid number" , preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: .Default, handler: nil))
            
            presentViewController(alert, animated: true, completion: nil)
            
        }
       
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
        
        
        if(Double(self.dishPriceTextField.text!) != nil ) {
            dish!.price = Double(self.dishPriceTextField.text!)
        }
        else
        {
            let alert = UIAlertController(title: "Alert", message: "\"Price\" must be a number", preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: .Default, handler: nil))
            
            presentViewController(alert, animated: true, completion: nil)
            
        }
        
        
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
        
        if (dishDescriptionTextField.text == "" || dishNameTextField.text == "" || dishDescriptionTextField.text == "" || dishImageView.image == nil) {
        
            let alert = UIAlertController(title: "warning", message: "please complete fill in all the blank", preferredStyle: .Alert)
            
            let action =  UIAlertAction(title: "ok", style: .Default, handler: nil)
            
            
            alert.addAction(action)
            
            
            presentViewController(alert, animated: true, completion: nil)
            
        } else
        {
        
            if dish != nil {
            
            editItem()
            } else {
            
            createNewItem()
            }
            
              self.delgate?.onClickFetchData()
            
            dissmissVC()
        }
        
      
        
        
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
 
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let vc =  segue.destinationViewController as! ScanViewController
        vc.delegate = self
        
      
         
    }
    

}
