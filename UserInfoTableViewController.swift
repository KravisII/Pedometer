//
//  UserInfoGoBackToPrepareView.swift
//  Pedometer
//
//  Created by Kravis on 16/9/5.
//  Copyright © 2016年 Kravis Liu. All rights reserved.
//

import UIKit

class UserInfoTableViewController: UITableViewController {
    
    var user_info: User_Struct?
    
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    
    @IBOutlet weak var heihtLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var BMILabel: UILabel!
    
    @IBAction func logOutToPrepareView(sender: UIButton) {
        CoreControl.deleteUserIDForLaunch()
        performSegueWithIdentifier("UserInfoGoBackToPrepareView", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let parent = parentViewController as? UINavigationController {
            if let grandParent = parent.parentViewController as? MainTabBarController {
                user_info = User.getUserInfoByID(grandParent.currentUserID!)
                if let value = user_info {
                    userIDLabel.text = value.id
                    emailLabel.text = value.email
                    genderLabel.text = value.gender
                    birthdayLabel.text = value.birthday
                    
                    heihtLabel.text = String(value.height!)
                    weightLabel.text = String(value.weight!)
                    BMILabel.text = String(format: "%.2f", value.BMI)
                }
            }
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
