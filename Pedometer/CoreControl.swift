//
//  CoreControl.swift
//  Pedometer
//
//  Created by Kravis Liu on 16/9/3.
//  Copyright © 2016年 Kravis Liu. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class CoreControl: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    static func getUserIDForLaunch() -> (CoreControl?) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let fetchRequest:NSFetchRequest = NSFetchRequest()
        fetchRequest.fetchLimit = 1 //限定查询结果的数量
        
        //设置数据请求的实体结构
        fetchRequest.entity = NSEntityDescription.entityForName("CoreControl", inManagedObjectContext: context)

        do {
            let fetchedObjects:[AnyObject]? = try context.executeFetchRequest(fetchRequest)
            guard fetchedObjects?.count > 0 else {
                print("Not Found")
                return nil
            }
            print("Found")
            return fetchedObjects![0] as? CoreControl
        }
        catch {
            fatalError("could not search：\(error)")
        }
    }
    
    static func deleteUserIDForLaunch() -> (String, String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let fetchRequest:NSFetchRequest =  NSFetchRequest()
        fetchRequest.fetchLimit = 1  // 限定查询结果的数量
    
        // 设置数据请求的实体结构
        fetchRequest.entity = NSEntityDescription.entityForName("CoreControl", inManagedObjectContext: context)
        
        do {
            let fetchedObjects:[AnyObject]? = try context.executeFetchRequest(fetchRequest)
            for info:CoreControl in fetchedObjects as! [CoreControl] {
                context.deleteObject(info)
            }
            try context.save()
            return ("Successful", "No problem")
        }
        catch {
            return ("Error", "Humm?... I don't know")
        }
        
    }
    
    static func addUserIDForLaunch(id: String) -> (String, String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let newToken = NSEntityDescription.insertNewObjectForEntityForName("CoreControl", inManagedObjectContext: context)
        
        newToken.setValue(id, forKey: "userIDForLaunch")

        do {
            try context.save()
            //            print("Save successful: \(newUser)")
            return ("Successful", "No problem")
        } catch {
            //            print("Could not cache the response \(error)")
            return ("Error", "Humm?... I don't know")
        }
    }
}
