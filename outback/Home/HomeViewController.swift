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

// MARK: - Main View Controller
class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  // MARK: - Properties & Outlets
  var viewModel = HomeViewModel()
  let cellSpacingHeight: CGFloat = 15
  @IBOutlet var tableView: UITableView!
  
  // MARK: - viewDidLoad, WillAppear
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Outback"
    
    // register the nib
    let cellNib = UINib(nibName: "TableViewCell", bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: "cell")
    
    
    viewModel.refresh { [unowned self] in
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
    
    // Self-sizing magic!
    tableView.delegate = self
    
    self.tableView.rowHeight = 175
    self.tableView.estimatedRowHeight = 175; //Set this to any value that works for you.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let selectedRow = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: selectedRow, animated: true)
    }
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
    cell.layer.borderColor = UIColor.black.cgColor
    cell.layer.borderWidth = 1
    cell.layer.cornerRadius = 8
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
