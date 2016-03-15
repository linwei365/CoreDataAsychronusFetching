//
//  TicketInfoViewController.swift
//  ResteurantPos
//
//  Created by Lin Wei on 3/11/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//

import UIKit
import CoreData


class TicketInfoViewController: UIViewController,SignUpUiViewDelegate {
    let moc =  (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var ticketInfos = [TicketInfo]()

    @IBOutlet weak var subUIView: SignUpUIView!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var companyStreetAddressTextField: UITextField!
    @IBOutlet weak var companyCity: UITextField!
    @IBOutlet weak var companyState: UITextField!
    @IBOutlet weak var companyZipCode: UITextField!
    @IBOutlet weak var CompanyPhoneNumber: UITextField!
    @IBOutlet weak var ticketTaxTextField: UITextField!
    @IBOutlet weak var ticketGratuityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.subUIView.delegate = self
        
        loadData()
        
        if (ticketInfos.count == 1){
            companyStreetAddressTextField.text = ticketInfos[0].companyStreetAddress
            companyCity.text = ticketInfos[0].companyCity
            companyNameTextField.text = ticketInfos[0].companyName
            companyState.text =   ticketInfos[0].companyState
            CompanyPhoneNumber.text = ticketInfos[0].compnayPhoneNumber
            ticketTaxTextField.text = ticketInfos[0].tax
            companyZipCode.text = ticketInfos[0].compnayZip
            ticketGratuityTextField.text =  ticketInfos[0].gratuity
        }

    }
    
        //custome dismiss keyboard protocol method
    func dismisskeyboard() {
        companyNameTextField.resignFirstResponder()
        companyStreetAddressTextField.resignFirstResponder()
        companyCity.resignFirstResponder()
        companyZipCode.resignFirstResponder()
        CompanyPhoneNumber.resignFirstResponder()
        ticketGratuityTextField.resignFirstResponder()
        ticketTaxTextField.resignFirstResponder()
        companyState.resignFirstResponder()
    }
    

 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData (){
        
        let fetchRequest = NSFetchRequest(entityName: "TicketInfo");
       
        do
        {
             ticketInfos = try moc.executeFetchRequest(fetchRequest) as! [TicketInfo]
        }
        catch{
            
            print("failed to fetch ticket Info")
            return
        }
        
       
        
    }
    
    
    
    
    
    
    @IBAction func saveOnClick(sender: UIBarButtonItem) {
        
        if (ticketInfos.count == 0)  {
            
            addNew()
        }
        else {
            
            edit()
        }
        
        
    }
    
    
    
    func addNew () {
        let ticketInfo = NSEntityDescription.insertNewObjectForEntityForName("TicketInfo", inManagedObjectContext: moc) as! TicketInfo
        
        ticketInfo.companyCity = companyCity.text
        ticketInfo.companyStreetAddress = companyStreetAddressTextField.text
        ticketInfo.companyName = companyNameTextField.text
        ticketInfo.companyState = companyState.text
        ticketInfo.compnayPhoneNumber = CompanyPhoneNumber.text
        ticketInfo.tax = ticketTaxTextField.text
        ticketInfo.compnayZip = companyZipCode.text
        ticketInfo.gratuity = ticketGratuityTextField.text
        
        
        
        do {
            try moc.save()
            navigationController?.popViewControllerAnimated(true)
        }
        catch{
            
            print("error to save ticket Info")
            return
        }
        
    }
    
    func edit(){
        
        ticketInfos[0].companyCity = companyCity.text
        
        ticketInfos[0].companyStreetAddress = companyStreetAddressTextField.text
        
        ticketInfos[0].companyName = companyNameTextField.text
        ticketInfos[0].companyState = companyState.text
        ticketInfos[0].compnayPhoneNumber = CompanyPhoneNumber.text
        ticketInfos[0].tax = ticketTaxTextField.text
        ticketInfos[0].compnayZip = companyZipCode.text
        ticketInfos[0].gratuity = ticketGratuityTextField.text
        
        do {
            try moc.save()
            navigationController?.popViewControllerAnimated(true)
        }
        catch{
            
            print("error to edit and save ticket Info")
            return
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
