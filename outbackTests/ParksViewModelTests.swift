//
//  ParksViewModelTests.swift
//  outbackTests
//
//  Created by Karan Bokil on 11/9/18.
//  Copyright © 2018 Karan Bokil. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import outback

class ParksViewModelTests: XCTestCase {
  var park1: Park!
  var park2: Park!
  var trail: Trail!
  var viewModel: ParksViewModel!
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    park1 = Park(entrance_fees: JSON(stringLiteral: "$10"), operating_hours: JSON(stringLiteral: "10pm-2pm"), full_name: "Park 1", states: "PA", latitude: "10", longitude: "10", url: "www.park.com", weatherInfo: "Clear", image: "Img", description: "Description 1")
    
    park2 = Park(entrance_fees: JSON(stringLiteral: "$10"), operating_hours: JSON(stringLiteral: "10pm-2pm"), full_name: "Park 2", states: "PA", latitude: "10", longitude: "10", url: "www.park.com", weatherInfo: "Clear", image: "Img", description: "Description 2")
    
    trail = Trail(name: "Name", summary: "Summary", difficulty: "Hard", rating: 5.0, url: "www.trail.com", img: "Image", length: 3, longitude: 10.0, latitude: 11.0, condition: "Windy", condition_details: "Lots of wind", park: park1, state: "PA")
    
    viewModel = ParksViewModel()
    viewModel.parks = [park1, park2]
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func test_numberOfRows() {
    XCTAssertEqual(viewModel.numberOfRows(), 2)
  }
  
  func test_titleForRowAtIndexPath() {
    XCTAssertEqual(viewModel.titleForRowAtIndexPath(IndexPath(row: 0, section: 0)), "Park 1")
    XCTAssertEqual(viewModel.titleForRowAtIndexPath(IndexPath(row: 1, section: 0)), "Park 2")

  }
  
  func test_summaryForRowAtIndexPath() {
    XCTAssertEqual(viewModel.summaryForRowAtIndexPath(IndexPath(row: 0, section: 0)), "Description 1")
    XCTAssertEqual(viewModel.summaryForRowAtIndexPath(IndexPath(row: 1, section: 0)), "Description 2")
  }
}
