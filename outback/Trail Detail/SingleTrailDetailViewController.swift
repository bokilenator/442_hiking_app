//
//  SingleTrailDetailViewController.swift
//  outback
//
//  Created by Graciela Garcia on 11/3/18.
//  Copyright © 2018 Karan Bokil. All rights reserved.
//

import UIKit

class SingleTrailDetailViewController: UIViewController {

  
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var stateLabel: UILabel!
  @IBOutlet weak var nationalParkLabel: UILabel!
  @IBOutlet weak var datesLabel: UILabel!
  
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
