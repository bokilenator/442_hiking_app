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
//    let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
    let shadowPath = UIBezierPath(roundedRect: self.layer.bounds, cornerRadius: 4)

    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOffset = CGSize(width: 0.5, height: 1)
    self.layer.shadowOpacity = 0.25
    self.layer.shadowPath = shadowPath.cgPath
//    contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))

  }
  
  override var frame: CGRect {
    get {
      return super.frame
    }
    set (newFrame) {
      var frame =  newFrame
      frame.origin.y += 10
      frame.size.height -= 2 * 6
      super.frame = frame
    }
  }
    
}


