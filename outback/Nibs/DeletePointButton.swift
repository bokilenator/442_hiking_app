//
//  DeletePointButton.swift
//  outback
//
//  Created by Karan Bokil on 11/29/18.
//  Copyright © 2018 Karan Bokil. All rights reserved.
//

import UIKit

class DeletePointButton: UIButton {
  override func awakeFromNib() {
    super.awakeFromNib()
    
    //TODO: Code for our button
    let color = UIColor.red
    let disabledColor = color.withAlphaComponent(0.3)
    
    let gradientColor1 = UIColor(red: 100.0 / 255.0, green: 100.0 / 255.0, blue: 100.0 / 255.0, alpha: 1).cgColor
    let gradientColor2 = UIColor(red: 50.0 / 255.0, green: 50.0 / 255.0, blue: 50.0 / 255.0, alpha: 1).cgColor
    
    let btnFont = "Noteworthy"
    let bthWidth = 200
    let btnHeight = 60
    
    self.frame.size = CGSize(width: bthWidth, height: btnHeight)
    self.frame.origin = CGPoint(x: (((superview?.frame.width)! / 2) - (self.frame.width / 2)), y: self.frame.origin.y)

    self.layer.cornerRadius = 10.0
    self.clipsToBounds = true
    self.layer.borderWidth = 3.0
    self.layer.borderColor = color.cgColor
    
    self.setTitleColor(color, for: .normal)
    self.setTitleColor(disabledColor, for: .disabled)
    self.titleLabel?.font = UIFont(name: btnFont, size: 25)
    self.titleLabel?.adjustsFontSizeToFitWidth = true
    self.setTitle(self.titleLabel?.text?.capitalized, for: .normal)
    
    let btnGradient = CAGradientLayer()
    btnGradient.frame = self.bounds
    btnGradient.colors = [gradientColor1, gradientColor2]
    self.layer.insertSublayer(btnGradient, at: 0)
    self.contentEdgeInsets.bottom = 4 //alternatively use: self.contentEdgeInsets.top = -4
  }
}
