//
//  FilterTrailViewController.swift
//  outback
//
//  Created by Karan Bokil on 12/6/18.
//  Copyright © 2018 Karan Bokil. All rights reserved.
//

import UIKit

class FilterTrailViewController: UIViewController {

  @IBOutlet weak var searchButton: UIButton!
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var titleLabel: UILabel!
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

  @IBAction func searchButton_TouchUpInside(_ sender: UIButton) {
//    dismiss(animated: true, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
      dismiss(animated: true)

  }
}
