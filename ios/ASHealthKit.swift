//
//  ASHealthKit.swift
//  AwesimSteps
//
//  Created by ASIM MALIK on 04/04/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

import Foundation
import HealthKit

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}
/*
 Custom event class to prevent deprecated errors
 
class MyEventEmitter: RCTEventEmitter {
  
  
  override func supportedEvents() -> [String]! {
    return ["UploadProgress"]
  }
  
}*/

@objc(RNHealthKit)
class RNHealthKit: NSObject {
  
  var bridge: RCTBridge!
  let healthKitStore:HKHealthStore = HKHealthStore()
  
  @objc func authorize(_ callback:@escaping RCTResponseSenderBlock) {
    checkAuthorization(){ authorized, error in
    //  NSLog(authorized ? "Authorized: Yes" : "Authorized: No");
      callback([NSNull(), authorized]);
    }
  }
  
  
  @objc func getSteps(_ startDate:Date, endDate:Date, callback:@escaping RCTResponseSenderBlock) {
    recentSteps(startDate, endDate: endDate) { steps, error in
      //NSLog("retrieved steps");
      callback([NSNull(), steps]);
    }
  }
  
  @objc func getWeeklySteps(_ startDate:Date, endDate:Date, anchorDate:Date, callback:@escaping RCTResponseSenderBlock){
    weeklySteps(startDate, endDate: endDate, anchorDate: anchorDate) { steps, error in
      //NSLog("retrieved weeklysteps");
      callback([NSNull(), steps]);
    }
  }
  
  func checkAuthorization(_ completion: @escaping (Bool, NSError?) -> ()) {
    
    if HKHealthStore.isHealthDataAvailable()
    {
      
      let steps = Set(arrayLiteral:
        HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!,
                      HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
      )

      healthKitStore.requestAuthorization(toShare: nil, read: steps) { (success, error) -> Void in
        var isEnabled = false
        
        if success  {
          isEnabled = success
        }
        completion(isEnabled, error as NSError?);
      }
    }
    
    //return isEnabled
  }
  
  func recentSteps(_ startDate:Date, endDate:Date, completion: @escaping (Double, NSError?) -> () )
  {
    let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions())
    
    let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: nil, resultsHandler: { query, results, error in
      var steps: Double = 0
      
      if results?.count > 0 {
        for s in results as! [HKQuantitySample]
        {
          steps += s.quantity.doubleValue(for: HKUnit.count())
          print(steps)
          print(s)
        }
      }
      completion(steps, error as NSError?)
    })
    
    healthKitStore.execute(query)
  }
  
  
  func weeklySteps(_ startDate:Date, endDate:Date, anchorDate:Date, completion: @escaping (Array<NSObject>, NSError?) -> ()) {
    let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
    var interval = DateComponents()
    interval.day = 1
    
    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
    
    let query = HKStatisticsCollectionQuery(quantityType: type!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: anchorDate, intervalComponents:interval)
    
    
    query.initialResultsHandler = { query, results, error in
      if let myResults = results{
        var stepsArray: [NSObject] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        myResults.enumerateStatistics(from: startDate, to: endDate) {
          statistics, stop in
          
          
          if let quantity = statistics.sumQuantity() {
            
            let date = statistics.startDate
            let steps = quantity.doubleValue(for: HKUnit.count())
            print("\(date): steps = \(steps)")
            
            let ret =  [
              "steps": steps,
              "startDate" : date.timeIntervalSince1970,
              "endDate": statistics.endDate.timeIntervalSince1970,
              "day": formatter.string(from: date)
            ] as [String : Any]
            
            //stepsArray.append(steps);
            stepsArray.append(ret as NSObject)
          }
          
        }
        
        completion(stepsArray, error as NSError?)
      }
    }
    
    healthKitStore.execute(query)
  }
  
  
  
  @objc func observeSteps() {
    let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
    
    let query = HKObserverQuery(sampleType: sampleType!, predicate: nil) {
      query, completionHandler, error in
      
      if error != nil {
        
        // Perform Proper Error Handling Here...
        //print("*** An error occured while setting up the stepCount observer. \(error!.localizedDescription) ***")
        abort()
      } else {
       // NSLog("Observed Steps")
        // If you have subscribed for background updates you must call the completion handler here.
        // completionHandler();
        let startDate = self.beginningOfDay()
        let endDate = Date()
        
        self.recentSteps(startDate, endDate: endDate) { steps, error in
          //NSLog("Observed steps changed");
          
          self.bridge.eventDispatcher().sendAppEvent(withName: "StepChangedEvent", body: steps)
        }
      }
      
    }
    
    healthKitStore.execute(query)
  }
  
  
  func beginningOfDay() -> Date {
    let calendar = Calendar.current
    let components = (calendar as NSCalendar).components([.year, .month, .day], from: Date())
    return calendar.date(from: components)!
  }
  
  
  
  
  
}
