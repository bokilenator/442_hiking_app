//
//  MapViewController.swift
//  outback
//
//  Created by Karan Bokil on 11/1/18.
//  Copyright © 2018 Karan Bokil. All rights reserved.
//

import Foundation
import UIKit
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
import SwiftyJSON

extension Double {
  /// Rounds the double to decimal places value
  func rounded(toPlaces places:Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
}

class MapViewController: UIViewController, MGLMapViewDelegate {
  
  var viewModel: MapViewModel?
  var mapView: NavigationMapView!
  var progressView: UIProgressView!
  var routePolyLine: MGLPolyline!
  var destinationCoords: [CLLocationCoordinate2D]!
  
  var startCoordinate = CLLocationCoordinate2D(latitude: 37.734328, longitude: -119.601744)
  var endCoordinate = CLLocationCoordinate2D(latitude: 37.728628, longitude: -119.573124)
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.title = viewModel?.title()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    

    // Do any additional setup after loading the view, typically from a nib.
    mapView = NavigationMapView(frame: view.bounds)
    mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(mapView)
    
    mapView.delegate = self
    mapView.styleURL = MGLStyle.outdoorsStyleURL
    mapView.showsUserLocation = true
//    mapView.setUserTrackingMode(.follow, animated: true)


    self.startCoordinate = viewModel?.startCoordinate() as! CLLocationCoordinate2D

    //add start marker
    let annotation = MGLPointAnnotation()
    annotation.coordinate = self.startCoordinate
    annotation.title = "Start Location"
    annotation.subtitle = "\(viewModel?.title() as! String), \(viewModel?.trail.park?.full_name as! String)"
    mapView.addAnnotation(annotation)
    
    mapView.setCenter(startCoordinate, zoomLevel: 16, animated: false)
    
    // Add a gesture recognizer to the map view
    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
    mapView.addGestureRecognizer(longPress)
    
    //navigate button
//    addButton()
    
    
    // Setup offline pack notification handlers.
    NotificationCenter.default.addObserver(self, selector: #selector(offlinePackProgressDidChange), name: NSNotification.Name.MGLOfflinePackProgressChanged, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(offlinePackDidReceiveError), name: NSNotification.Name.MGLOfflinePackError, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(offlinePackDidReceiveMaximumAllowedMapboxTiles), name: NSNotification.Name.MGLOfflinePackMaximumMapboxTilesReached, object: nil)
  }
  
  @objc func didLongPress(_ sender: UILongPressGestureRecognizer) {
    guard sender.state == .began else { return }
    guard (destinationCoords == nil || destinationCoords.count <= 9)
      else {
        print("Can't add more than 10 points")
        return
    }
    
    // Converts point where user did a long press to map coordinates
    let point = sender.location(in: mapView)
    let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
    
    // Create a basic point annotation and add it to the map
    let annotation = MGLPointAnnotation()
    annotation.coordinate = coordinate
    annotation.title = "Waypoint: \(coordinate.latitude.rounded(toPlaces: 3)), \(coordinate.longitude.rounded(toPlaces: 3))"
    mapView.addAnnotation(annotation)
    
    
    calculateOptimizedRoute(from: startCoordinate, to: annotation.coordinate) { (route, error) in
      if error != nil {
        print("Error calculating route")
      }
    }
  }
  // Retrieve optimization api data
  func calculateOptimizedRoute(from origin: CLLocationCoordinate2D,
                               to destination: CLLocationCoordinate2D,
                               completion: @escaping (Route?, Error?) -> ()) {
    if (destinationCoords == nil) {
      destinationCoords = []
    }
    destinationCoords.append(destination)
    clearPolyLine()
    //Mapbox geojson uses long, lat!
    let accessToken = "sk.eyJ1Ijoia2Jva2lsIiwiYSI6ImNqbXhteHZmeTBjangzcWxydHRjbHc2MXAifQ.y5ybeyL8pcy0L2Z9aPTSSg"
    let originString = "\(origin.longitude),\(origin.latitude);"
    let destinationString = destinationCoordsToString()
    let midPointString = "\(origin.longitude - 0.0001),\(origin.latitude)"
    let distributionString = "1,2"
    
    let url:String = "https://api.mapbox.com/optimized-trips/v1/mapbox/walking/" + originString + destinationString + midPointString + "?distributions=" + distributionString + "&overview=full&steps=true&geometries=geojson&source=first&access_token=" + accessToken
    let optURL: NSURL = NSURL(string: url)!
    let data = NSData(contentsOf: optURL as URL)!
    
    do {
      let swiftyjson = try JSON(data: data as Data)
      let coords = swiftyjson["trips"][0]["geometry"]["coordinates"].array
      var coordinates:[CLLocationCoordinate2D] = []
      for coord in coords ?? [] {
        let c = coord.arrayValue
        coordinates.append(CLLocationCoordinate2D(latitude: c[1].doubleValue, longitude: c[0].doubleValue))
      }
      print(coordinates)
      routePolyLine = MGLPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
      mapView.addAnnotation(routePolyLine)
    } catch let error as NSError {
      print(error)
    }
    
  }
  
  func clearPolyLine() {
    if (routePolyLine != nil) {
      mapView.removeAnnotation(routePolyLine)
    }
  }
  
  func destinationCoordsToString() -> String {
    var res = ""
    for destination in self.destinationCoords {
      res = res + "\(destination.longitude),\(destination.latitude);"
    }
    return String(res[..<res.endIndex])
    
  }
  
  // Implement the delegate method that allows annotations to show callouts when tapped
  func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
    return true
  }
  
  // Present the navigation view controller when the callout is selected
  func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
  }
  
  
  //offline handling
  func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
    // Start downloading tiles and resources for z13-16.
    startOfflinePackDownload()
  }
  
  deinit {
    // Remove offline pack observers.
    NotificationCenter.default.removeObserver(self)
  }
  
  func startOfflinePackDownload() {
    // Create a region that includes the current viewport and any tiles needed to view it when zoomed further in.
    // Because tile count grows exponentially with the maximum zoom level, you should be conservative with your `toZoomLevel` setting.
    let region = MGLTilePyramidOfflineRegion(styleURL: mapView.styleURL, bounds: mapView.visibleCoordinateBounds, fromZoomLevel: mapView.zoomLevel, toZoomLevel: 16)
    
    // Store some data for identification purposes alongside the downloaded resources.
    let userInfo = ["name": "My Offline Pack"]
    let context = NSKeyedArchiver.archivedData(withRootObject: userInfo)
    
    // Create and register an offline pack with the shared offline storage object.
    
    MGLOfflineStorage.shared.addPack(for: region, withContext: context) { (pack, error) in
      guard error == nil else {
        // The pack couldn’t be created for some reason.
        print("Error: \(error?.localizedDescription ?? "unknown error")")
        return
      }
      
      // Start downloading.
      pack!.resume()
    }
    
  }
  
  // MARK: - MGLOfflinePack notification handlers
  
  @objc func offlinePackProgressDidChange(notification: NSNotification) {
    // Get the offline pack this notification is regarding,
    // and the associated user info for the pack; in this case, `name = My Offline Pack`
    if let pack = notification.object as? MGLOfflinePack,
      let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String] {
      let progress = pack.progress
      // or notification.userInfo![MGLOfflinePackProgressUserInfoKey]!.MGLOfflinePackProgressValue
      let completedResources = progress.countOfResourcesCompleted
      let expectedResources = progress.countOfResourcesExpected
      
      // Calculate current progress percentage.
      let progressPercentage = Float(completedResources) / Float(expectedResources)
      
      // Setup the progress bar.
      if progressView == nil {
        progressView = UIProgressView(progressViewStyle: .default)
        let frame = view.bounds.size
        progressView.frame = CGRect(x: frame.width / 4, y: frame.height * 0.75, width: frame.width / 2, height: 10)
        view.addSubview(progressView)
      }
      
      progressView.progress = progressPercentage
      
      // If this pack has finished, print its size and resource count.
      if completedResources == expectedResources {
        let byteCount = ByteCountFormatter.string(fromByteCount: Int64(pack.progress.countOfBytesCompleted), countStyle: ByteCountFormatter.CountStyle.memory)
        print("Offline pack “\(userInfo["name"] ?? "unknown")” completed: \(byteCount), \(completedResources) resources")
        progressView.alpha = 0
      } else {
        // Otherwise, print download/verification progress.
        print("Offline pack “\(userInfo["name"] ?? "unknown")” has \(completedResources) of \(expectedResources) resources — \(progressPercentage * 100)%.")
      }
    }
  }
  
  @objc func offlinePackDidReceiveError(notification: NSNotification) {
    if let pack = notification.object as? MGLOfflinePack,
      let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
      let error = notification.userInfo?[MGLOfflinePackUserInfoKey.error] as? NSError {
      print("Offline pack “\(userInfo["name"] ?? "unknown")” received error: \(error.localizedFailureReason ?? "unknown error")")
    }
  }
  
  @objc func offlinePackDidReceiveMaximumAllowedMapboxTiles(notification: NSNotification) {
    if let pack = notification.object as? MGLOfflinePack,
      let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
      let maximumCount = (notification.userInfo?[MGLOfflinePackUserInfoKey.maximumCount] as AnyObject).uint64Value {
      print("Offline pack “\(userInfo["name"] ?? "unknown")” reached limit of \(maximumCount) tiles.")
    }
  }
  
}




