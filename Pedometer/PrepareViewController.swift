//
//  PrepareViewController.swift
//  Pedometer
//
//  Created by Kravis on 16/9/4.
//  Copyright © 2016年 Kravis Liu. All rights reserved.
//

import UIKit

class PrepareViewController: UIViewController {
    
    private var userID: String?
    
    @IBAction func goBackToPrepareView(segue: UIStoryboardSegue) {
        if let viewControllerIdentifier = segue.sourceViewController.restorationIdentifier {
            switch viewControllerIdentifier {
            case "RegisterView":
                print("Hello, I am back from RegisterView.")
            case "SignInView":
                print("Hello, I am back from SignInView.")
            default:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        var segueIdentifier = "goToIntroView"
        if let userID = CoreControl.getUserIDForLaunch() {
            print(userID.userIDForLaunch!)
            self.userID = userID.userIDForLaunch!
            print("I am PrepareView, going to MainView")
            segueIdentifier = "goToMainView"
        }
        performSegueWithIdentifier(segueIdentifier, sender: self)
        // TODO: 传递 userID 到 MainView
    }
    
    deinit {
        print("PrepareViewController is dead")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("I am PrepareView prepareForSegue function")
        print("des: \(segue.destinationViewController)")
        if let destination = segue.destinationViewController as? MainTabBarController {
            destination.currentUserID = userID
        }
    }
}
