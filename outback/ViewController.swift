//
//  ViewController.swift
//  outback
//
//  Created by Karan Bokil on 10/29/18.
//  Copyright © 2018 Karan Bokil. All rights reserved.
//

import UIKit
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections


class ViewController: UIViewController, MGLMapViewDelegate {
  var mapView: NavigationMapView!
  var directionsRoute: Route?
  var navigateButton: UIButton!
  
  let startCoordinate = CLLocationCoordinate2D(latitude: 37.734328, longitude: -119.601744)
  let endCoordinate = CLLocationCoordinate2D(latitude: 37.728628, longitude: -119.573124)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    mapView = NavigationMapView(frame: view.bounds)
    mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(mapView)
    
    mapView.delegate = self
//    mapView.styleURL = MGLStyle.outdoorsStyleURL
    mapView.showsUserLocation = true
    mapView.setUserTrackingMode(.follow, animated: true)
    
    addButton()
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
      lineStyle.lineWidth = NSExpression(forConstantValue: 4.0)
      
      mapView.style?.addSource(source)
      mapView.style?.addLayer(lineStyle)
      
    }
  }
  
}


