//
//  ParksViewModel.swift
//  outback
//
//  Created by Karan Bokil on 11/5/18.
//  Copyright © 2018 Karan Bokil. All rights reserved.
//

import Foundation
import SwiftyJSON

class ParksViewModel {
  var parks = [Park]()
  //  var filteredRepos = [Repository]()
  
  //  let client = SearchRepositoriesClient()
  //  let parser = RepositoriesParser()
  
  func refresh(_ completion: @escaping () -> Void) {
    //    client.fetchRepositories { [unowned self] data in
    //      if let repositories = self.parser.repositoriesFromSearchResponse(data) {
    //        self.repos = repositories
    //      }
    let api_key = "xc3zAWXsavAseuzrUYem0sscY7tJpFiUpnoIr6jD"
    // set search parameters
    let search_state = "CA"
    let search_park = ""
//    search_park = "Yosemite" //uncomment to search by park name too
    
    // create api url
    let npsURL: NSURL = NSURL(string: "https://api.nps.gov/api/v1/parks?stateCode=\(search_state)&q=\(search_park)&api_key=\(api_key)&fields=fullName%2Cstates%2Curl%2CweatherInfo%2CoperatingHours%2CentranceFees%2Cimages")!
    
    // collect data from api
    let data = NSData(contentsOf: npsURL as URL)
    if (data == nil) {
      return
    }
    
    do {
      let swiftyjson = try JSON(data: data as! Data)
      let total = swiftyjson["total"].int!
      for i in 0..<total {
        let entrance_fees = swiftyjson["data"][i]["entranceFees"] as JSON
        let operating_hours = swiftyjson["data"][i]["operatingHours"][0] as JSON
        let full_name = swiftyjson["data"][i]["fullName"].string ?? ""
        let states = swiftyjson["data"][i]["states"].string ?? ""
        
        let coordinates = swiftyjson["data"][i]["latLong"].string ?? "lat:0, long:0"
        let parseCoords = parseCoordinates(coordinates: coordinates)
        let latitude = parseCoords[0]
        let longitude = parseCoords[1]
        
        let url = swiftyjson["data"][i]["url"].string ?? ""
        let weatherInfo = swiftyjson["data"][i]["weatherInfo"].string ?? ""
        let image = swiftyjson["data"][i]["images"][0]["url"].string ?? ""
        let description = swiftyjson["data"][i]["description"].string ?? ""

        
        if (full_name != "" && parseCoords != ["0", "0"]) {
          let park = Park.init(entrance_fees: entrance_fees, operating_hours: operating_hours, full_name: full_name, states: states, latitude: latitude, longitude: longitude, url: url, weatherInfo: weatherInfo, image: image, description: description)
          parks.append(park)
        }
      }

    } catch let error as NSError {
      print(error)
    }
    completion()
    
  }
  
  func parseCoordinates(coordinates: String) -> [String] {
    if (coordinates == "") {
      return ["0", "0"]
    }
    let coordsArr = coordinates.components(separatedBy: ", ")
    let lat = coordsArr[0].components(separatedBy: "lat:")[1]
    let long = coordsArr[1].components(separatedBy: "long:")[1]
    return [lat, long]
  }
  
  func numberOfRows() -> Int {
    return parks.count
  }
  
  func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String {
    guard indexPath.row >= 0 && indexPath.row < parks.count else {
      return ""
    }
    return parks[indexPath.row].full_name
  }
  
  func summaryForRowAtIndexPath(_ indexPath: IndexPath) -> String {
    guard indexPath.row >= 0 && indexPath.row < parks.count else {
      return ""
    }
    return parks[indexPath.row].description
    
  }
  
  func detailViewModelForRowAtIndexPath(_ indexPath: IndexPath) -> TrailsViewModel {
    let park = parks[indexPath.row]
    return TrailsViewModel(park: park)
  }
  
  //  func updateFiltering(_ searchText: String) -> Void {
  //    filteredRepos = self.repos.filter { repo in
  //      return repo.name.lowercased().contains(searchText.lowercased())
  //    }
  //  }
}
