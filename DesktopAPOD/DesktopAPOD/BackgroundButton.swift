//
//  BackgroundButton.swift
//  DesktopAPOD
//
//  Created by Richard Ash on 5/13/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import Cocoa

class BackgroundButton: NSButton {
  
  // MARK: - Private Properties
  
  private let originalText = "Set Background 🚀"
  private let failText = "Update Failed 😞"
  private let successText = "Updated Succeeded 🛰"
  
  // MARK: - Overridden Methods
  
  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
    layer?.cornerRadius = 5.0
  }
  
  // MARK: - Methods
  
  func animateUpdateFailed() {
    animateBackgroundColor(to: NSColor.red.cgColor, text: failText)
  }

  func animateUpdateSucceeded() {
    animateBackgroundColor(to: NSColor.green.cgColor, text: successText)
  }
  
  // MARK: - Private Methods
  
  private func animateBackgroundColor(to color: CGColor, text: String) {
    let backgroundColorAnimation = CABasicAnimation(keyPath: "backgroundColor")
    backgroundColorAnimation.fromValue = layer?.backgroundColor
    backgroundColorAnimation.toValue = color
    backgroundColorAnimation.duration = 0.33
    title = text
    
    layer?.add(backgroundColorAnimation, forKey: nil)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
      self.title = self.originalText
    }
  }
}
