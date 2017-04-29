//
//  Spinner.swift
//
//
//  Created by Richard Ash on 4/29/17.
//
//

import Cocoa

class Spinner: NSProgressIndicator {
  
  // MARK: - Overridden Methods
  
  override func awakeFromNib() {
    super.awakeFromNib()
    startAnimation(nil)
  }
  
  // MARK: - Methods
  
  func showAnimated() {
    let animation = CABasicAnimation(keyPath: "isHidden")
    animation.fromValue = true
    animation.toValue = false
    animation.duration = 0.25
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    layer?.add(animation, forKey: nil)
    isHidden = false
  }
  
  func hideAnimated() {
    let animation = CABasicAnimation(keyPath: "isHidden")
    animation.fromValue = false
    animation.toValue = true
    animation.duration = 0.25
    layer?.add(animation, forKey: nil)
    isHidden = true
  }
}
