//
//  TableViewCell.swift
//  Repos
//

import UIKit

class TableViewCell: UITableViewCell {
  
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var summary: UILabel!
  @IBOutlet weak var picPreview: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
//    contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))

  }
    
}
