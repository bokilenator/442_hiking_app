//
//  MapViewModelTests.swift
//  outbackTests
//
//  Created by Karan Bokil on 11/9/18.
//  Copyright © 2018 Karan Bokil. All rights reserved.
//

import XCTest
import SwiftyJSON
import Mapbox
@testable import outback

class MapViewModelTests: XCTestCase {
  var park: Park!
  var trail: Trail!
  var viewModel: MapViewModel!
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    park = Park(entrance_fees: JSON(stringLiteral: "$10"), operating_hours: JSON(stringLiteral: "10pm-2pm"), full_name: "Park", states: "PA", latitude: "10", longitude: "10", url: "www.park.com", weatherInfo: "Clear", image: "Img", description: "Description")
    
    trail = Trail(name: "Name", summary: "Summary", difficulty: "Hard", rating: 5.0, url: "www.trail.com", img: "Image", length: 3, longitude: 10.0, latitude: 11.0, condition: "Windy", condition_details: "Lots of wind", park: park, state: "PA")
    
    viewModel = MapViewModel(trail: trail)
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func test_title() {
    XCTAssertEqual(viewModel.title(), "Name")
  }
  
  func test_startCoordinate() {
    let ans = CLLocationCoordinate2D(latitude: 11.0, longitude: 10.0)
    XCTAssertEqual(ans, viewModel.startCoordinate())
  }

}
