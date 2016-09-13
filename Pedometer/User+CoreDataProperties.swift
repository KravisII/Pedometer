//
//  User+CoreDataProperties.swift
//  Pedometer
//
//  Created by Kravis Liu on 16/9/3.
//  Copyright © 2016年 Kravis Liu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var birthday: NSDate?
    @NSManaged var email: String?
    @NSManaged var gender: NSNumber?
    @NSManaged var height: NSNumber?
    @NSManaged var id: String?
    @NSManaged var password: String?
    @NSManaged var weight: NSNumber?
    @NSManaged var exercise: NSSet?

}
