//
//  RegisterTableViewController.swift
//  Pedometer
//
//  Created by Kravis Liu on 16/8/29.
//  Copyright © 2016年 Kravis Liu. All rights reserved.
//

import UIKit

class RegisterTableViewController: UITableViewController, UITextFieldDelegate
{
    private var textFields: [UITextField] = []
    
    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBAction func submitForRegister(sender: UIButton) {
        submitRegisterInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTextFieldToArray()
    }
    
    override func viewWillDisappear(animated: Bool) {
        for textField in textFields {
            if textField.isFirstResponder() {
                textField.resignFirstResponder()
            }
        }
    }
    
    private func submitRegisterInfo() {
        let (statusTitle, statusMessage) = User.addNewUserId(userIDTextField.text!,
                                                             email: emailTextField.text!,
                                                             password: passwordTextField.text!,
                                                             gender: genderSegmentedControl.selectedSegmentIndex,
                                                             birthday: birthdayTextField.text!,
                                                             height: Int(heightTextField.text!)! ,
                                                             weight: Int(weightTextField.text!)!)
        
        if statusTitle == "Successful" {
            CoreControl.addUserIDForLaunch(userIDTextField.text!)
            performSegueWithIdentifier("registerGoBackToPrepareView", sender: self)
        } else {
            showMessage(statusTitle, message: statusMessage)
        }
        
        // TODO: statusTitle 为 Successful 后跳转
    }
    
    private func showMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func addTextFieldToArray() {
        textFields.append(userIDTextField)
        textFields.append(emailTextField)
        textFields.append(passwordTextField)
        textFields.append(birthdayTextField)
        textFields.append(heightTextField)
        textFields.append(weightTextField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let index = textFields.indexOf(textField) {
            print("index: \(index)")
            if index == textFields.count - 1 {
                submitRegisterInfo()
            } else {
                textFields[index+1].becomeFirstResponder()
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == birthdayTextField {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .Date
            textField.inputView = datePicker
            datePicker.addTarget(self, action: #selector(self.dateValueChanged(_:)), forControlEvents: .ValueChanged)
        }
    }
    
    func dateValueChanged(sender: UIDatePicker) {
        let dateFormater = NSDateFormatter()
        dateFormater.dateStyle = .MediumStyle
        birthdayTextField.text = dateFormater.stringFromDate(sender.date)
    }
    
    deinit {
        print("Register Table View is dead")
    }
}
