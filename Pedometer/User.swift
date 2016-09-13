//
//  User.swift
//  Pedometer
//
//  Created by Kravis on 16/8/30.
//  Copyright © 2016年 Kravis Liu. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct User_Struct {
    var id: String
    var email: String
    var gender: String
    var birthday: String
    var height: Int?
    var weight: Int?
    var BMI: Double {
        get {
            if height != nil && weight != nil {
                let h = Double(height!) / 100.0
                let w = Double(weight!)
                return w / (h * h)
            } else {
                return 0.0
            }
        }
    }
}

class User: NSManagedObject {
    static func getDateFromString(dateStr: String) -> NSDate {
        let dateFormater = NSDateFormatter()
        dateFormater.dateStyle = .MediumStyle
        dateFormater.timeZone = NSTimeZone.systemTimeZone()
        return dateFormater.dateFromString(dateStr)!
    }
    
    static func getGenderBool(genderInt: Int) -> Bool {
        return genderInt == 0 ? true : false
    }
    
    static func addNewUserId(id: String, email: String, password: String, gender: Int, birthday: String, height: Int, weight: Int) -> (String, String) {
        if id.isEmpty || email.isEmpty || password.isEmpty || birthday.isEmpty {
            return ("Error", "Some info is empty.")
        }
        
        if let user = User.findUserID(id) {
            return ("Error", "The User \"\(user.id!)\" already exist.")
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context)
        
        newUser.setValue(id, forKey: "id")
        
        newUser.setValue(email, forKey: "email")
        
        newUser.setValue(password, forKey: "password")
        
        let genderBool = getGenderBool(gender)
        newUser.setValue(genderBool, forKey: "gender")
        
        let date = getDateFromString(birthday)
        newUser.setValue(date, forKey: "birthday")
        
        newUser.setValue(height, forKey: "height")
        newUser.setValue(weight, forKey: "weight")
        
        do {
            try context.save()
            //            print("Save successful: \(newUser)")
            return ("Successful", "No problem")
        } catch {
            //            print("Could not cache the response \(error)")
            return ("Error", "Humm?... I don't know")
        }
    }
    
    static func findUserID(id: String) -> User? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        //必须使用新 fetch
        let fetchRequest:NSFetchRequest = NSFetchRequest()
        fetchRequest.fetchLimit = 1 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量
        
        //设置数据请求的实体结构
        fetchRequest.entity = NSEntityDescription.entityForName("User", inManagedObjectContext: context)
        
        fetchRequest.predicate = NSPredicate(format: "id = '\(id)'", "")
        
        
        //查询操作
        do {
            let fetchedObjects:[AnyObject]? = try context.executeFetchRequest(fetchRequest)
            guard fetchedObjects?.count > 0 else {
                return nil
            }
            return fetchedObjects![0] as? User
        }
        catch {
            fatalError("could not search：\(error)")
        }
    }
    
    static func getUserInfoByID(id: String) -> User_Struct? {
        
        if let user = findUserID(id) {
            let gender =  Bool(user.gender!) ? "Male" : "Female"
            
            let dateFormater = NSDateFormatter()
            dateFormater.dateStyle = .MediumStyle
            let birthday = dateFormater.stringFromDate(user.birthday!)
            
            let result = User_Struct(id: user.id!, email: user.email!, gender: gender, birthday: birthday, height: Int(user.height!), weight: Int(user.weight!))
            print(result)
            return result
        } else {
            return nil
        }
    }
    
    // Insert code here to add functionality to your managed object subclass
    
}


