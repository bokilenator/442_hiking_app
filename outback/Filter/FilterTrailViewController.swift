//
//  FilterTrailViewController.swift
//  outback
//
//  Created by Karan Bokil on 12/6/18.
//  Copyright © 2018 Karan Bokil. All rights reserved.
//

import UIKit
import Eureka

class FilterTrailViewController: FormViewController {

  let viewModel = ParksViewModel()
  @IBOutlet weak var searchButton: UIButton!
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var titleLabel: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Filter Trails"
    
    IntRow.defaultCellUpdate = { cell, row in
      if !row.isValid {
        cell.titleLabel?.textColor = .red
      }
    }
    
    
    
    form +++ Section("Select State/Park")
      <<< ActionSheetRow<String>("stateTag") {
        $0.title = "State"
        $0.selectorTitle = "Pick a state"
        $0.options = States().states
        $0.add(rule: RuleRequired())
        $0.validationOptions = .validatesOnChangeAfterBlurred
        $0.onChange({ row in
          self.viewModel.search_state = row.value ?? ""
          self.refresh()

        })
      }
      
        .cellUpdate { cell, row in
          if !row.isValid {
            cell.textLabel?.textColor = .red
          }
        }
        .onRowValidationChanged { cell, row in
          let rowIndex = row.indexPath!.row
          while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
            row.section?.remove(at: rowIndex + 1)
          }
          if !row.isValid {
            for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
              let labelRow = LabelRow() {
                $0.title = validationMsg
                $0.cell.height = { 30 }
              }
              row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
            }
          }
      }
      
      
      
      <<< SwitchRow("freeTag"){
        $0.title = "No entrance fee"
        $0.value = true
        $0.onChange({ row in
          self.viewModel.free_park = row.value!
          self.refresh()
        })
      }
      
      <<< ActionSheetRow<String>("parkTag") {
        $0.hidden = "$stateTag == nil"
        $0.title = "National Park"
        $0.add(rule: RuleRequired())
        $0.validationOptions = .validatesOnChangeAfterBlurred
        $0.selectorTitle = "Pick a park"
        $0.options = viewModel.parks.map { $0.full_name }
      }
        .cellUpdate { cell, row in
          if !row.isValid {
            cell.textLabel?.textColor = .red
          }
        }
        .onRowValidationChanged { cell, row in
          let rowIndex = row.indexPath!.row
          while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
            row.section?.remove(at: rowIndex + 1)
          }
          if !row.isValid {
            for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
              let labelRow = LabelRow() {
                $0.title = validationMsg
                $0.cell.height = { 30 }
              }
              row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
            }
          }
    }
    
    
    
      
     form +++ Section("Select Properties")
      <<< IntRow() {
        $0.tag = "distanceTag"
        $0.title = "Minimum Distance" //min 0 max 200
        $0.add(rule: RuleGreaterOrEqualThan(min: 0))
        $0.add(rule: RuleSmallerOrEqualThan(max: 200))
        $0.value = 0
      }

      <<< IntRow() {
        $0.tag = "ratingTag"
        $0.title = "Minimum Rating" //min 0 max 4
        $0.add(rule: RuleGreaterOrEqualThan(min: 0))
        $0.add(rule: RuleSmallerOrEqualThan(max: 4))
        $0.value = 0
      }
    
      +++ Section()
      <<< ButtonRow() {
        $0.title = "Search"
        }
        .onCellSelection { cell, row in
          let errors:[ValidationError] = row.section?.form?.validate() ?? []
          if (errors.count == 0) {
            self.performSegue(withIdentifier: "toTrailsVC", sender: self)
          }
    }


  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toTrailsVC" {
      let destinationVC = segue.destination as! TrailsViewController
      let parkName: String = self.form.rowBy(tag: "parkTag")!.value!
      let park = self.viewModel.parks.first(where: {$0.full_name == parkName})
      let distance = self.form.rowBy(tag: "distanceTag")?.baseValue as! Int
      let rating = self.form.rowBy(tag: "ratingTag")?.baseValue as! Int

      print(park?.full_name)
      destinationVC.viewModel = TrailsViewModel(park: park, rating: rating, distance: distance)
    }
  }
  


  
  func refresh() {
    self.viewModel.refresh { [unowned self] in
      DispatchQueue.main.async {
        let park: ActionSheetRow<String> = self.form.rowBy(tag: "parkTag")!
        park.value = nil
        park.options = self.viewModel.parks.map { $0.full_name }
        self.tableView.reloadData()
        
      }
    }
    
  }
}
