//
//  Itinerary+CoreDataProperties.swift
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

extension Itinerary {

    @NSManaged var date: NSDate?
    @NSManaged var step: NSNumber?
    @NSManaged var person: User?

}
