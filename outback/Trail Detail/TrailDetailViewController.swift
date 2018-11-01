//
//  TrailDetailViewController.swift
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

class TrailDetailViewController: UIViewController, MGLMapViewDelegate {
  
  var viewModel: TrailDetailViewModel?
  var mapView: NavigationMapView!
  var progressView: UIProgressView!
  var directionsRoute: Route?
  var navigateButton: UIButton!
  
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
    annotation.title = "Kinkaku-ji"
    annotation.subtitle = "\(annotation.coordinate.latitude), \(annotation.coordinate.longitude)"
    mapView.addAnnotation(annotation)
    
    mapView.setCenter(startCoordinate, zoomLevel: 16, animated: false)
    
    //navigate button
    addButton()
    
    
    // Setup offline pack notification handlers.
    NotificationCenter.default.addObserver(self, selector: #selector(offlinePackProgressDidChange), name: NSNotification.Name.MGLOfflinePackProgressChanged, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(offlinePackDidReceiveError), name: NSNotification.Name.MGLOfflinePackError, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(offlinePackDidReceiveMaximumAllowedMapboxTiles), name: NSNotification.Name.MGLOfflinePackMaximumMapboxTilesReached, object: nil)
  }
  
  func addButton() {
    navigateButton = UIButton(frame: CGRect(x: (view.frame.width/2)-100, y: view.frame.height - 75, width: 200, height: 50))
    navigateButton.backgroundColor = UIColor.white
    navigateButton.setTitle("   NAVIGATE   ", for: .normal)
    navigateButton.setTitleColor(UIColor(red: 59/255, green: 178/255, blue: 208/255, alpha: 1), for: .normal)
    navigateButton.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
    navigateButton.layer.cornerRadius = 25
    navigateButton.layer.shadowOffset = CGSize(width: 0, height: 10)
    navigateButton.layer.shadowColor = UIColor.black.cgColor
    navigateButton.layer.shadowRadius = 5
    navigateButton.layer.shadowOpacity = 0.3
    navigateButton.addTarget(self, action: #selector(navigateButtonWasPressed(sender:)), for: .touchUpInside)
    view.addSubview(navigateButton)
  }
  
  @objc func navigateButtonWasPressed( sender: UIButton) {
    mapView.setUserTrackingMode(.none, animated: true)
    
    calculateRoute(from: startCoordinate, to: endCoordinate, completion: { (route, error) in
      if error != nil {
        print("Error getting route")
      }
    })
  }
  
  func calculateRoute(from originCoor: CLLocationCoordinate2D, to destinationCoor: CLLocationCoordinate2D, completion: @escaping (Route?, Error?) -> Void) {
    let origin = Waypoint(coordinate: originCoor, coordinateAccuracy: -1, name: "Start")
    let destination = Waypoint(coordinate: destinationCoor, coordinateAccuracy: -1, name: "Finish")
    
    let options = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: .walking)
    
    _ = Directions.shared.calculate(options, completionHandler: { (waypoints, routes, error) in
      self.directionsRoute = routes?.first
      self.drawRoute(route: self.directionsRoute!)
      
      let coordinateBounds = MGLCoordinateBounds(sw: destinationCoor, ne: originCoor)
      let insets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
      let routeCam = self.mapView.cameraThatFitsCoordinateBounds(coordinateBounds, edgePadding: insets)
      self.mapView.setCamera(routeCam, animated: true)
    })
  }
  
  func drawRoute(route: Route) {
    guard route.coordinateCount > 0 else { return }
    var routeCoordinates = route.coordinates!
    let polyline = MGLPolylineFeature(coordinates: &routeCoordinates, count: route.coordinateCount)
    
    if let source = mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
      source.shape = polyline
    } else {
      let source = MGLShapeSource(identifier: "route-source", features: [polyline], options: nil)
      
      let lineStyle = MGLLineStyleLayer(identifier: "route-style", source: source)
      lineStyle.lineColor = NSExpression(forConstantValue: UIColor(red: 41/255, green: 145/255, blue: 171/255, alpha: 1))
      lineStyle.lineWidth = NSExpression(forConstantValue: 5.0)
      
      mapView.style?.addSource(source)
      mapView.style?.addLayer(lineStyle)
      
    }
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



