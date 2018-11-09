//
//  TrailsViewModelTests.swift
//  outbackTests
//
//  Created by Karan Bokil on 11/9/18.
//  Copyright © 2018 Karan Bokil. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import outback

class TrailsViewModelTests: XCTestCase {
  var park: Park!
  var trail1: Trail!
  var trail2: Trail!
  var viewModel: TrailsViewModel!
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    park = Park(entrance_fees: JSON(stringLiteral: "$10"), operating_hours: JSON(stringLiteral: "10pm-2pm"), full_name: "Park 1", states: "PA", latitude: "10", longitude: "10", url: "www.park.com", weatherInfo: "Clear", image: "Img", description: "Description 1")
    
    trail1 = Trail(name: "Name 1", summary: "Summary 1", difficulty: "Hard 1", rating: 5.0, url: "www.trail1.com", img: "Image 1", length: 3, longitude: 10.0, latitude: 11.0, condition: "Windy", condition_details: "Lots of wind 1", park: park, state: "PA")
    
    trail2 = Trail(name: "Name 2", summary: "Summary 2", difficulty: "Hard 2", rating: 4.0, url: "www.trail2.com", img: "Image 2", length: 5, longitude: 12.0, latitude: 13.0, condition: "Sunny", condition_details: "Lots of sun", park: park, state: "CA")
    
    viewModel = TrailsViewModel(park: park)
    viewModel.trails = [trail1, trail2]
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func test_numberOfRows() {
    XCTAssertEqual(viewModel.numberOfRows(), 2)
  }
  
  func test_titleForRowAtIndexPath() {
    XCTAssertEqual(viewModel.titleForRowAtIndexPath(IndexPath(row: 0, section: 0)), "Name 1")
    XCTAssertEqual(viewModel.titleForRowAtIndexPath(IndexPath(row: 1, section: 0)), "Name 2")
    
  }
  
  func test_summaryForRowAtIndexPath() {
    XCTAssertEqual(viewModel.summaryForRowAtIndexPath(IndexPath(row: 0, section: 0)), "Summary 1")
    XCTAssertEqual(viewModel.summaryForRowAtIndexPath(IndexPath(row: 1, section: 0)), "Summary 2")
  }
  
  func test_detailViewModelForRowAtIndexPath() {
    XCTAssertEqual(viewModel.detailViewModelForRowAtIndexPath(IndexPath(row: 0, section: 0)).trail.name, "Name 1")
  }
}
