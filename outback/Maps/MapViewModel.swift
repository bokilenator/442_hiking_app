//
//  MapViewModel.swift
//  outback
//
//  Created by Karan Bokil on 11/1/18.
//  Copyright © 2018 Karan Bokil. All rights reserved.
//

import Foundation
import CoreLocation


class MapViewModel {
  let trail: Trail
  
  init(trail: Trail) {
    self.trail = trail
  }
  
  func title() -> String {
    return trail.name
  }

  
  func startCoordinate() -> CLLocationCoordinate2D {
    var startCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(trail.latitude), longitude: CLLocationDegrees(trail.longitude))
    return startCoordinate
  }

}
