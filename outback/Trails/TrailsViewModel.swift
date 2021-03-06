//
//  TrailsViewModel.swift
//  outback
//
//  Created by Karan Bokil on 11/1/18.
//  Copyright © 2018 Karan Bokil. All rights reserved.
//

import Foundation
import SwiftyJSON

class TrailsViewModel {
  
  var park:Park? = nil
  var rating:Int = 0
  var distance:Int = 0
  
  init(park: Park?, rating: Int = 0, distance: Int = 0) {
    self.park = park
    self.rating = rating
    self.distance = distance
  }
  
  var trails = [Trail]()
//  var filteredRepos = [Repository]()
  
//  let client = SearchRepositoriesClient()
//  let parser = RepositoriesParser()
  
  func refresh(_ completion: @escaping () -> Void) {
//    client.fetchRepositories { [unowned self] data in
//      if let repositories = self.parser.repositoriesFromSearchResponse(data) {
//        self.repos = repositories
//      }
    let api_key = "200375104-0392bc18905efe70f4e0062b073c01fe"
    var search_lat = "37.84883288"
    var search_long = "-119.5571873"
    
    if (self.park != nil) {
      search_lat = park?.latitude as! String
      search_long = park?.longitude as! String
    }
    
    let search_distance = "200"
    let search_sort = "quality"
    let npsURL: NSURL = NSURL(string: "https://www.hikingproject.com/data/get-trails?lat=\(search_lat)&lon=\(search_long)&maxDistance=\(search_distance)&minLength=\(distance)&minStars=\(rating)&sort=\(search_sort)&key=\(api_key)")!
    let data = NSData(contentsOf: npsURL as URL)
    if (data == nil) {
      return
    }
    do {
      let swiftyjson = try JSON(data: data as! Data)
      let total = swiftyjson["trails"].count
      for i in 0..<total {
        let name = swiftyjson["trails"][i]["name"].string ?? ""
        let summary = swiftyjson["trails"][i]["summary"].string ?? ""
        let difficulty = swiftyjson["trails"][i]["difficulty"].string ?? ""
        let rating = swiftyjson["trails"][i]["stars"].float!
        let url = swiftyjson["trails"][i]["url"].string ?? ""
        let img = swiftyjson["trails"][i]["imgMedium"].string ?? ""
        let length = swiftyjson["trails"][i]["length"].int!
        let longitude = swiftyjson["trails"][i]["longitude"].float!
        let latitude = swiftyjson["trails"][i]["latitude"].float!
        let condition = swiftyjson["trails"][i]["conditionStatus"].string ?? ""
        let condition_details: String = swiftyjson["trails"][i]["conditionDetails"].string ?? ""
        let trail = Trail.init(name: name, summary: summary, difficulty: difficulty, rating: rating, url: url, img: img, length: length, longitude: longitude, latitude: latitude, condition: condition, condition_details: condition_details, park: park, state: "CA") //need to update to get state from search query
        trails.append(trail)
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
  
//  func updateFiltering(_ searchText: String) -> Void {
//    filteredRepos = self.repos.filter { repo in
//      return repo.name.lowercased().contains(searchText.lowercased())
//    }
//  }
}
