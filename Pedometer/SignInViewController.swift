//
//  SignInViewController.swift
//  Pedometer
//
//  Created by Kravis Liu on 16/8/28.
//  Copyright © 2016年 Kravis Liu. All rights reserved.
//

import UIKit

class SignInTableViewController: UITableViewController, UITextFieldDelegate
{
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func submitButtonTouchedUp(sender: UIButton) {
        submitSignInInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
        accountTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == accountTextField {
            passwordTextField.becomeFirstResponder()
        }
        
        if textField == passwordTextField {
            submitSignInInfo()
        }
        
        return true
    }
    
    private func submitSignInInfo() {
        if let user = User.findUserID(accountTextField.text!) {
            if let password = passwordTextField.text {
                if password == user.password! {
                    passwordTextField.resignFirstResponder()
                    
                    CoreControl.addUserIDForLaunch(user.id!)
                    performSegueWithIdentifier("signInGoBackToPrepareView", sender: self)
                } else {
                    showMessage("Error", message: "The User is found, but password is incorrect.")
                }
            }
        } else {
            accountTextField.becomeFirstResponder()
            showMessage("Error", message: "The User not found.")
        }
    }
    
    private func showMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
