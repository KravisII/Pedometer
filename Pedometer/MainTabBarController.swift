//
//  MainTabBarController.swift
//  Pedometer
//
//  Created by Kravis Liu on 16/9/3.
//  Copyright © 2016年 Kravis Liu. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    var currentUserID: String? {
        didSet {
            print("I am MainTabBarController")
            print(currentUserID!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
