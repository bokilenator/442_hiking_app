//
//  Plan.swift
//  outback
//
//  Created by Karan Bokil on 11/1/18.
//  Copyright © 2018 Karan Bokil. All rights reserved.
//

import Foundation
import Mapbox
import CoreData

struct Route {
//  let trail: Trail
//  let startDate: NSDate
//  let endDate: NSDate
  let routePolyLine: MGLPolyline

}

class Plan: NSManagedObject {
  
  @NSManaged var routePolyLine: MGLPolyline
  
  var route : Route {
    get {
      return Route(routePolyLine: self.routePolyLine)
    }
    set {
      self.routePolyLine = newValue.routePolyLine
    }
  }
}
