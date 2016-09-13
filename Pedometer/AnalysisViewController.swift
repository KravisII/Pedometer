//
//  AnalysisViewController.swift
//  Pedometer
//
//  Created by Kravis on 16/9/8.
//  Copyright © 2016年 Kravis Liu. All rights reserved.
//

import UIKit
import HealthKitUI

class AnalysisTableViewController: UITableViewController {
    
    @IBOutlet weak var dayUIView: UIView!
    @IBOutlet weak var weekUIView: UIView!
    
    @IBOutlet weak var dayStepsLablel: UILabel!
    @IBOutlet weak var dayStepsGoalLabel: UILabel!
    @IBOutlet weak var dayDistanceLabel: UILabel!
    @IBOutlet weak var dayDistanceGoalLabel: UILabel!
    @IBOutlet weak var dayEnergyBurnedLabel: UILabel!
    
    @IBOutlet weak var weekStepsLablel: UILabel!
    @IBOutlet weak var weekStepsGoalLabel: UILabel!
    @IBOutlet weak var weekDistanceLabel: UILabel!
    @IBOutlet weak var weekDistanceGoalLabel: UILabel!
    @IBOutlet weak var weekEnergyBurnedLabel: UILabel!
    
    @IBAction func refresh(sender: UIRefreshControl) {
        updateData()
        sender.endRefreshing()
    }
    
    @IBAction func newGoal(sender: UIBarButtonItem) {
        // TODO 带输入框的 alert
    }
    
    @IBAction func playRingView(sender: UIBarButtonItem) {
        resetView(dayUIView.subviews[0] as! HKActivityRingView)
        resetView(weekUIView.subviews[0] as! HKActivityRingView)
    }
    
    var weight: Double?
    
    var daySteps = 0.0 {
        didSet {
            dayStepsLablel.text = String(daySteps)
            dayDistanceLabel.text = String(daySteps * 0.65) + "m"
            let energyBurned = weight! * (daySteps * 0.65 / 1000) * 1.036
            dayEnergyBurnedLabel.text = String(format: "%.2f", energyBurned)
            //        更新图表
            updateActivityRingView(dayUIView, value: daySteps, goal: dayStepsGoal)
        }
    }
    
    var weekSteps = 0.0 {
        didSet {
            weekStepsLablel.text = String(weekSteps)
            weekDistanceLabel.text = String(weekSteps * 0.65) + "m"
            let energyBurned = weight! * (weekSteps * 0.65 / 1000) * 1.036
            weekEnergyBurnedLabel.text = String(format: "%.2f", energyBurned)
            //        更新图表
            updateActivityRingView(weekUIView, value: weekSteps, goal: dayStepsGoal * 7)
        }
    }
    
    var dayStepsGoal = 0.0 {
        didSet {
            dayStepsGoalLabel.text = String(dayStepsGoal)
            weekStepsGoalLabel.text = String(dayStepsGoal * 7)
            
            dayDistanceGoalLabel.text = String(format: "%.2f", dayStepsGoal * 0.65)
            weekDistanceGoalLabel.text = String(format: "%.2f", dayStepsGoal * 0.65 * 7)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        设置默认值
        dayStepsGoal = 5000
        //        设置体重
        getWeight()
        
        
        //        创建图表
        createActivityRingView(forView: dayUIView)
        createActivityRingView(forView: weekUIView)
        
        //        更新数据
        updateData()
    }
    
    private func createActivityRingView(forView view: UIView) {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: dayUIView.bounds.size)
        let activityRing = HKActivityRingView(frame: rect)
        let summary = HKActivitySummary()
        summary.activeEnergyBurned = HKQuantity(unit: HKUnit.kilocalorieUnit(), doubleValue: 0)
        summary.activeEnergyBurnedGoal = HKQuantity(unit: HKUnit.kilocalorieUnit(), doubleValue: 0)
        summary.appleExerciseTime = HKQuantity(unit: HKUnit.minuteUnit(), doubleValue: 0)
        summary.appleExerciseTimeGoal = HKQuantity(unit: HKUnit.minuteUnit(), doubleValue: 0)
        summary.appleStandHours = HKQuantity(unit: HKUnit.countUnit(), doubleValue: 0)
        summary.appleStandHoursGoal = HKQuantity(unit: HKUnit.countUnit(), doubleValue: 0)
        activityRing.setActivitySummary(summary, animated: true)
        view.addSubview(activityRing)
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
    
    
    private func updateData() {
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
                    self.daySteps = totalDistance
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
                    self.weekSteps = totalDistance
                })
            }
        }
        
        HKHealthStore().executeQuery(statisticsSumQuery_week)
    }
    
    private func updateActivityRingView(view: UIView, value: Double, goal: Double) {
        let activityRing = view.subviews[0] as! HKActivityRingView
        
        let summary = HKActivitySummary()
        let defaultValue1: Double = Double(arc4random() % 20)
        let defaultValue2: Double = Double(arc4random() % 20)
        // TODO 生成随机数
        let defaultGoal: Double = 10
        
        summary.activeEnergyBurned = HKQuantity(unit: HKUnit.kilocalorieUnit(), doubleValue: value)
        summary.activeEnergyBurnedGoal = HKQuantity(unit: HKUnit.kilocalorieUnit(), doubleValue: goal)
        
        summary.appleExerciseTime = HKQuantity(unit: HKUnit.minuteUnit(), doubleValue: defaultValue1)
        summary.appleExerciseTimeGoal = HKQuantity(unit: HKUnit.minuteUnit(), doubleValue: defaultGoal)
        
        summary.appleStandHours = HKQuantity(unit: HKUnit.countUnit(), doubleValue: defaultValue2)
        summary.appleStandHoursGoal = HKQuantity(unit: HKUnit.countUnit(), doubleValue: defaultGoal)
        
        activityRing.setActivitySummary(summary, animated: true)
        //        view.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    func resetView(view: HKActivityRingView) {
        let summary = HKActivitySummary()
        
        let defaultValue1: Double = Double(arc4random() % 20)
        let defaultValue2: Double = Double(arc4random() % 20)
        let defaultValue3: Double = Double(arc4random() % 20)
        let defaultGoal: Double = 10
        
        summary.activeEnergyBurned = HKQuantity(unit: HKUnit.kilocalorieUnit(), doubleValue: defaultValue3)
        summary.activeEnergyBurnedGoal = HKQuantity(unit: HKUnit.kilocalorieUnit(), doubleValue: defaultGoal)
        
        summary.appleExerciseTime = HKQuantity(unit: HKUnit.minuteUnit(), doubleValue: defaultValue1)
        summary.appleExerciseTimeGoal = HKQuantity(unit: HKUnit.minuteUnit(), doubleValue: defaultGoal)
        
        summary.appleStandHours = HKQuantity(unit: HKUnit.countUnit(), doubleValue: defaultValue2)
        summary.appleStandHoursGoal = HKQuantity(unit: HKUnit.countUnit(), doubleValue: defaultGoal)
        
        view.setActivitySummary(summary, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
