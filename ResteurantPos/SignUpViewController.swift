//
//  SignUpViewController.swift
//  ResteurantPos
//
//  Created by Lin Wei on 2/27/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//

import UIKit
import CoreData

class SignUpViewController: UIViewController,UITextFieldDelegate,SignUpUiViewDelegate,UIScrollViewDelegate {
    let moc =  (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!

    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var repeatpasswordTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var signUpUIView: SignUpUIView!
    
    
    func dismisskeyboard() {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        repeatpasswordTextField.resignFirstResponder()
        
    
        
        
    }
    
//    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        
//        firstNameTextField.resignFirstResponder()
//        lastNameTextField.resignFirstResponder()
//        emailTextField.resignFirstResponder()
//        usernameTextField.resignFirstResponder()
//        passwordTextField.resignFirstResponder()
//        repeatpasswordTextField.resignFirstResponder()
//        
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      signUpUIView.delegate = self
        
        
        scrollView.contentSize.height = 500
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //dismiss keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
 
        
     
        
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        repeatpasswordTextField.resignFirstResponder()
        
        
        
        firstNameTextField.endEditing(true)
        
        
        
        return true
    }
    
    
    @IBAction func cancelOnClick(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    @IBAction func doneOnClick(sender: UIBarButtonItem) {
        
      save()
    }
    
    
    func save () {
        
        
        let user =  NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: moc) as! User
      
        if (usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty || emailTextField.text!.isEmpty || firstNameTextField.text!.isEmpty || lastNameTextField.text!.isEmpty ){
        
            let alertController =  UIAlertController(title: "Error", message: "please complete all the blanks", preferredStyle: .Alert)
            
            let action =  UIAlertAction (title: "Ok", style: .Default, handler: nil)
            
            alertController.addAction(action)
            
            presentViewController(alertController, animated: true, completion: nil)
            
        
        }
        else if (passwordTextField.text !=  repeatpasswordTextField.text) {
                
                let alertController =  UIAlertController(title: "Password not matched", message: "make sure passward are matching", preferredStyle: .Alert)
                
                let action =  UIAlertAction (title: "Ok", style: .Default, handler: nil)
                
                alertController.addAction(action)
                
                presentViewController(alertController, animated: true, completion: nil)
                
            }
            else {
            
            user.username = usernameTextField.text
            user.password = passwordTextField.text
            user.email = emailTextField.text
            user.firstName = firstNameTextField.text
            user.lastName = lastNameTextField.text
            
            do {
                try moc.save()
                self.dismissViewControllerAnimated(true, completion: nil)
                
            }
            catch {
                
                print("error to save ")
                return
            }
            
            
        }
            
     
            
            

   
        
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
