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

class Plan:NSManagedObject {
//  let trail: Trail
//  let startDate: NSDate
//  let endDate: NSDate
  @NSManaged var name: String
  @NSManaged var routePolyLine: MGLPolyline
  @NSManaged var coordinates: [CLLocationCoordinate2D]

}
