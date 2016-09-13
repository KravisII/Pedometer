//
//  PedometerTableViewController.swift
//  Pedometer
//
//  Created by Kravis on 16/9/5.
//  Copyright © 2016年 Kravis Liu. All rights reserved.
//

import UIKit
import HealthKit

extension NSDate {
    func xDays(x: Int) -> NSDate {
        return NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: x, toDate: self, options: [])!
    }
    
    func cleanHours() -> NSDate {
        return NSCalendar.currentCalendar().dateBySettingHour(0, minute: 0, second: 0, ofDate: self, options: [])!
    }
}

class PedometerTableViewController: UITableViewController {
    
    var weight: Double?
    
    enum DistanceUnit {
        case m;
        case km
    }
    
    var currentUnit: DistanceUnit = .m
    
    @IBOutlet weak var daySteps: UILabel!
    @IBOutlet weak var weekSteps: UILabel!
    @IBOutlet weak var monthSteps: UILabel!
    
    @IBOutlet weak var dayDistance: UILabel!
    @IBOutlet weak var weekDistance: UILabel!
    @IBOutlet weak var monthDistance: UILabel!
    
    @IBOutlet weak var dayCalories: UILabel!
    @IBOutlet weak var weekCalories: UILabel!
    @IBOutlet weak var monthCalories: UILabel!
    
    @IBAction func unitChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: currentUnit = .m
        case 1: currentUnit = .km
        default: break
        }
        print(currentUnit)
        queryDistanceSum()
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        queryDistanceSum()
        sender.endRefreshing()
    }
    
    func checkAuthorization() -> Bool {
        var isEnabled = true
        
        // Do we have access to HealthKit on this device?
        if HKHealthStore.isHealthDataAvailable() {
            // We have to request each data type explicitly
            let steps = NSSet(object: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!)
            
            // Now we can request authorization for step count data
            HKHealthStore().requestAuthorizationToShareTypes(nil, readTypes: steps as? Set<HKObjectType>) { (success, error) -> Void in
                isEnabled = success
            }
        } else {
            isEnabled = false
        }
        
        return isEnabled
    }
    
    func queryDistanceSum() {
        let stepsCount = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        let sumOption = HKStatisticsOptions.CumulativeSum
        let endDate = NSDate()
        let startDate = endDate.cleanHours()
        print("startDate: \(startDate), endDate: \(endDate)")
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: [])
        let statisticsSumQuery = HKStatisticsQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: sumOption) {
            [unowned self] (query, result, error) in
            if let sumQuantity = result?.sumQuantity() {
                dispatch_async(dispatch_get_main_queue(), {
                    let totalDistance = sumQuantity.doubleValueForUnit(HKUnit.countUnit())
                    self.daySteps.text = String(totalDistance)
                    
                    let distance = totalDistance * 0.65
                    switch self.currentUnit {
                    case .m: self.dayDistance.text = String(distance)
                    case .km: self.dayDistance.text = String(format: "%.2f", distance/1000)
                    }
                    
                    let calories = self.weight! * (distance / 1000) * 1.036
                    self.dayCalories.text = String(format: "%.2f", calories)
                })
            }
        }
        
        HKHealthStore().executeQuery(statisticsSumQuery)
        
        let endDate_week = NSDate()
        let startDate_week = endDate.xDays(-7)
        let predicate_week = HKQuery.predicateForSamplesWithStartDate(startDate_week, endDate: endDate_week, options: [])
        let statisticsSumQuery_week = HKStatisticsQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate_week, options: sumOption) {
            [unowned self] (query, result, error) in
            if let sumQuantity = result?.sumQuantity() {
                dispatch_async(dispatch_get_main_queue(), {
                    let totalDistance = sumQuantity.doubleValueForUnit(HKUnit.countUnit())
                    self.weekSteps.text = String(totalDistance)
                    
                    let distance = totalDistance * 0.65
                    switch self.currentUnit {
                    case .m: self.weekDistance.text = String(distance)
                    case .km: self.weekDistance.text = String(format: "%.2f", distance/1000)
                    }
                    
                    let calories = self.weight! * (distance / 1000) * 1.036
                    self.weekCalories.text = String(format: "%.2f", calories)
                })
            }
        }
        
        HKHealthStore().executeQuery(statisticsSumQuery_week)
        
        let endDate_month = NSDate()
        let startDate_month = endDate.xDays(-30)
        let predicate_month = HKQuery.predicateForSamplesWithStartDate(startDate_month, endDate: endDate_month, options: [])
        let statisticsSumQuery_month = HKStatisticsQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate_month, options: sumOption) {
            [unowned self] (query, result, error) in
            if let sumQuantity = result?.sumQuantity() {
                dispatch_async(dispatch_get_main_queue(), {
                    let totalDistance = sumQuantity.doubleValueForUnit(HKUnit.countUnit())
                    self.monthSteps.text = String(totalDistance)
                    
                    let distance = totalDistance * 0.65
                    switch self.currentUnit {
                    case .m: self.monthDistance.text = String(distance)
                    case .km: self.monthDistance.text = String(format: "%.2f", distance/1000)
                    }
                    
                    let calories = self.weight! * (distance / 1000) * 1.036
                    self.monthCalories.text = String(format: "%.2f", calories)
                })
            }
        }
        HKHealthStore().executeQuery(statisticsSumQuery_month)
    }
    
    private func getWeight() {
        if let parent = parentViewController as? UINavigationController {
            if let grandParent = parent.parentViewController as? MainTabBarController {
                if let user_info = User.getUserInfoByID(grandParent.currentUserID!) {
                    weight = Double(user_info.weight!)
                }
            }
        }
    }
    
    // Then whenever you need to update the distance sum call the function
    // with the closure, then handle the result as needed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getWeight()
        checkAuthorization()
        queryDistanceSum()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
