//
//  LogInViewController.swift
//  ResteurantPos
//
//  Created by Lin Wei on 3/14/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, SignUpUiViewDelegate {

    @IBOutlet weak var subUIView: SignUpUIView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize.height = 700
        subUIView.delegate = self

        // Do any additional setup after loading the view.
    }

    func dismisskeyboard() {
        userNameTextField.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
    }
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
