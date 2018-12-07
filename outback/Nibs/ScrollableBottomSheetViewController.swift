//
//  ScrollableBottomSheetViewController.swift
//  BottomSheet
//
//  Created by Ahmed Elassuty on 10/15/16.
//  Copyright © 2016 Ahmed Elassuty. All rights reserved.
//

import UIKit

class ScrollableBottomSheetViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
//    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var trailNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var nationalParkLabel: UILabel!

  @IBOutlet weak var ratingLabel: UILabel!
  
  @IBOutlet weak var entranceFeeLabel: UILabel!
  @IBOutlet weak var summaryLabel: UILabel!
  
  @IBOutlet weak var datePicker: UIDatePicker!
  
  let fullView: CGFloat = 100
    var mapController: MapViewController!
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - 150
    }

  @IBAction func datePickerChanged(_ sender: UIDatePicker) {
    mapController.date = sender.date
  }
  override func viewDidLoad() {
        super.viewDidLoad()
        trailNameLabel.font = UIFont.systemFont(ofSize: 27)
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UINib(nibName: "DefaultTableViewCell", bundle: nil), forCellReuseIdentifier: "default")
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(ScrollableBottomSheetViewController.panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackgroundView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height - 100)
            })
      datePicker.setValue(UIColor.white, forKeyPath: "textColor")
      datePicker.setValue(false, forKey: "highlightsToday")
      datePicker.setDate(mapController.date, animated: true)
      
      trailNameLabel.text = mapController.viewModel?.title()
      distanceLabel.text = String(mapController.viewModel!.trail.length) + " mi"
      stateLabel.text = "STATE: " + (mapController.viewModel?.trail.state)!
      nationalParkLabel.text = "AREA: " + (mapController.viewModel?.trail.park?.full_name)!
      let fee: Bool = mapController.viewModel!.trail.park!.entrance_fees
      entranceFeeLabel.text = "PASS REQUIRED: " +  (fee ? "Yes" : "No")
      ratingLabel.text = "RATINGS: " + String(repeating: "⭐", count: Int(mapController.viewModel?.trail.rating ?? 0.0))
      summaryLabel.text = "SUMMARY: " + (mapController.viewModel?.trail.summary)!
      
      
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  

  
  @IBAction func savedPressed(sender: UIButton) {
    mapController.save()
  }
  
  @IBAction func clearPressed(sender: UIButton) {
    if Connectivity.isConnectedToInternet() {
      print("Yes! internet is available.")
      mapController.clear()
    } else {
      mapController.showAlert(message: "Cannot add/remove waypoints offline!")
    }
  }
    
  @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)

        let y = self.view.frame.minY
        if (y + translation.y >= fullView) && (y + translation.y <= partialView) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }
                
                }, completion: { [weak self] _ in
                    if ( velocity.y < 0 ) {
//                        self?.tableView.isScrollEnabled = true
                    }
            })
        }
    }
    
    
    func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .dark)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        view.insertSubview(bluredView, at: 0)
    }

}

extension ScrollableBottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "default")!
    }
}

extension ScrollableBottomSheetViewController: UIGestureRecognizerDelegate {

    // Solution
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y

        let y = view.frame.minY
//        if (y == fullView && tableView.contentOffset.y == 0 && direction > 0) || (y == partialView) {
//            tableView.isScrollEnabled = false
//        } else {
//            tableView.isScrollEnabled = true
//        }
      
        return false
    }
    
}
