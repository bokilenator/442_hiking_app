//
//  TrailDetailViewController.swift
//  outback
//
//  Created by Graciela Garcia on 11/3/18.
//  Copyright © 2018 Karan Bokil. All rights reserved.
//

import Foundation
import UIKit

class TrailDetailsViewController: UIViewController {
  
  var viewModel: TrailDetailsViewModel?

  @IBOutlet weak var trailNameLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var stateLabel: UILabel!
  @IBOutlet weak var nationalParkLabel: UILabel!
  @IBOutlet weak var datesLabel: UILabel!
  @IBOutlet weak var availabilityLabel: UILabel!
  
  
  
//Trail Model:
//  let name: String
//  let summary: String
//  let difficulty: String
//  let rating: Float
//  let url: String
//  let img: String
//  let length: Int
//  let longitude: Float
//  let latitude: Float
//  let condition: String
//  let condition_details: String
//  let park: Park?
  
//Park Model:
//  let entrance_fees: JSON
//  let operating_hours: JSON
//  let full_name: String
//  let states: String
//  let latitude:String
//  let longitude: String
//  let url: String
//  let weatherInfo: String
//  let image: String
//  let description: String
  
 
  
  @IBAction func saveTrail(_ sender: Any) {
  }
  
//  @IBAction func downloadMap(_ sender: Any) {
//  }
  

  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateLabels()
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func updateLabels() {
    if let viewModel = viewModel {
      trailNameLabel.text = viewModel.trail.name
      distanceLabel.text = String(viewModel.trail.length) + " mi"
      stateLabel.text = viewModel.trail.state ?? ""
      nationalParkLabel.text = viewModel.trail.park?.full_name ?? "N/A"
      

    }
  }
    

  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toMap"
    {
      if let destinationVC = segue.destination as? MapViewController {
        destinationVC.viewModel = viewModel?.mapViewModel()
      }
    }
  }
  
//    @IBOutlet weak var distanceLabel: UILabel!
//    @IBOutlet weak var stateLabel: UILabel!
//    @IBOutlet weak var nationalParkLabel: UILabel!
//    @IBOutlet weak var datesLabel: UILabel!
//    @IBOutlet weak var availabilityLabel: UILabel!
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
