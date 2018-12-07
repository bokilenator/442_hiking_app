//
//  HomeViewModel.swift
//  outback
//
//  Created by Karan Bokil on 12/7/18.
//  Copyright © 2018 Karan Bokil. All rights reserved.
//
import Foundation
import SwiftyJSON
import CoreData

class HomeViewModel {
  
  
  init() {

  }
  
  var trails = [Trail]()

  func refresh(_ completion: @escaping () -> Void) {
    trails = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Plan")
    request.returnsObjectsAsFaults = false
   
    do {
      let result = try context.fetch(request)
      for data in result as! [NSManagedObject] {
        if let plan:Plan = data as? Plan {
          let park:Park = Park(entrance_fees: plan.parkdata?.entrance_fees ?? true, full_name: plan.parkdata?.full_name ?? "Park", states: plan.parkdata?.states ?? "CA", latitude: plan.parkdata?.latitude ?? "0.0", longitude: plan.parkdata?.longitude ?? "0.0", url: plan.parkdata?.url ?? "", weatherInfo: plan.parkdata?.weatherInfo ?? "Warm", image: plan.parkdata?.image ?? "", description: plan.parkdata?.description ?? "A cool park")

          let trail:Trail = Trail(name: (plan.traildata?.name!)!, summary: (plan.traildata?.summary!)!, difficulty: (plan.traildata?.difficulty!)!, rating: (plan.traildata?.rating)!, url: (plan.traildata?.url!)!, img: (plan.traildata?.img!)!, length: Int(plan.traildata?.length as! Int64), longitude: (plan.traildata?.longitude)!, latitude: (plan.traildata?.latitude)!, condition: (plan.traildata?.condition!)!, condition_details: (plan.traildata?.condition_details!)!, park: park, state: plan.traildata?.state!)

          trails.append(trail)
        }
      }
    } catch let error as NSError {
      print(error)
    }
    
    completion()
    
  }
  
  func numberOfRows() -> Int {
    return trails.count
  }
  
  func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String {
    guard indexPath.row >= 0 && indexPath.row < trails.count else {
      return ""
    }
    return trails[indexPath.row].name
  }
  
  func summaryForRowAtIndexPath(_ indexPath: IndexPath) -> String {
    guard indexPath.row >= 0 && indexPath.row < trails.count else {
      return ""
    }
    return "\(trails[indexPath.row].length) mi" + String(repeating: " ", count: (3 - String(trails[indexPath.row].length).count)) + "\t \t \t" + String(repeating: "⭐", count: Int(trails[indexPath.row].rating))
    
  }
  
  func pictureForRowAtIndexPath(_ indexPath: IndexPath) -> String {
    guard indexPath.row >= 0 && indexPath.row < trails.count else {
      return ""
    }
    return trails[indexPath.row].img
    
  }
  
  func detailViewModelForRowAtIndexPath(_ indexPath: IndexPath) -> MapViewModel {
    let trail = trails[indexPath.row]
    return MapViewModel(trail: trail)
  }
  
}
