//
//  HomeViewController.swift
//  outback
//
//  Created by Karan Bokil on 12/7/18.
//  Copyright © 2018 Karan Bokil. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit
import Kingfisher
import CoreGraphics

// MARK: - Main View Controller
class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  // MARK: - Properties & Outlets
  var viewModel = HomeViewModel()
  let cellSpacingHeight: CGFloat = 15
  @IBOutlet var tableView: UITableView!
  private let refreshControl = UIRefreshControl()

  // MARK: - viewDidLoad, WillAppear
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Outback"
    
    // register the nib
    let cellNib = UINib(nibName: "TableViewCell", bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: "cell")
    
    
    refresh()
    if #available(iOS 10.0, *) {
      tableView.refreshControl = refreshControl
    } else {
      tableView.addSubview(refreshControl)
    }
    
    refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)


    
    // Self-sizing magic!
    tableView.delegate = self
    
    self.tableView.rowHeight = 190
    self.tableView.estimatedRowHeight = 190; //Set this to any value that works for you.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let selectedRow = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: selectedRow, animated: true)
    }
  }
  
  
  func refresh(){
    viewModel.refresh { [unowned self] in
      DispatchQueue.main.async {
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
//        self.activityIndicatorView.stopAnimating()
      }
    }
  }
  
  @objc private func refresh(_ sender: Any) {
    // Fetch Weather Data
    refresh()
  }
  
  // MARK: - Table View
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
    cell.name?.text = viewModel.titleForRowAtIndexPath(indexPath)
    cell.summary?.text = viewModel.summaryForRowAtIndexPath(indexPath)
    cell.picPreview.kf.indicatorType = .activity
    cell.picPreview.kf.setImage(with: URL(string: viewModel.pictureForRowAtIndexPath(indexPath)))
    // add border and color
    cell.backgroundColor = UIColor.white
    cell.layer.borderColor = UIColor.lightGray.cgColor
    cell.layer.borderWidth = 1
    cell.layer.cornerRadius = 4
    cell.clipsToBounds = true

    
    return cell
  }
  
  // Set the spacing between sections
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return cellSpacingHeight
  }
  
  // Make the background color show through
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = UIColor.clear
    return headerView
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "toMapVC", sender: indexPath)
  }
  
  // MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let detailVC = segue.destination as? MapViewController,
      let indexPath = sender as? IndexPath {
      detailVC.viewModel = viewModel.detailViewModelForRowAtIndexPath(indexPath)
    }
  }

}
