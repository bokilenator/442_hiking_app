//
//  SingleTrailDetailViewController.swift
//  outback
//
//  Created by Graciela Garcia on 11/3/18.
//  Copyright © 2018 Karan Bokil. All rights reserved.
//

import Foundation
import UIKit

class TrailDetailsViewController: UIViewController {
  
  
  @IBOutlet weak var trailNameLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var stateLabel: UILabel!
  @IBOutlet weak var nationalParkLabel: UILabel!
  @IBOutlet weak var datesLabel: UILabel!
  @IBOutlet weak var availabilityLabel: UILabel!
  
  
  var detailItem: Trail? {
    didSet {
      // Update the view.
      self.configureView()
    }
  }
  
  func configureView() {
    // Update the user interface for the detail item.
    if let detail: Trail = self.detailItem {
      if let name = self.trailNameLabel {
        name.text = detail.name
      }
      if let length = self.distanceLabel{
        length.text = String(detail.length)
      }
      //      if let state = self.stateLabel {
      //        state.text = detail.state
      //      }
      //      if let nationalPark = self.nationalParkLabel {
      //        nationalPark.text = detail.nationalPark
      //      }
      //      if let dates = self.datesLabel {
      //        dates.text = detail.dates
      //      }
      if let condition = self.availabilityLabel {
        condition.text = detail.condition
      }
    }
  }
  
  
  @IBAction func saveTrail(_ sender: Any) {
  }
  
  @IBAction func downloadMap(_ sender: Any) {
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
