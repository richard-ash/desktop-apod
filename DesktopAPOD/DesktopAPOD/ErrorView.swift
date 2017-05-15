//
//  ErrorView.swift
//  DesktopAPOD
//
//  Created by Richard Ash on 5/15/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import Cocoa

class ErrorView: NSView {
  
  // MARK: - IBOutlet Properties
  
  @IBOutlet weak var errorLabel: NSTextField!
  
  // MARK: - Overridden Methods
  
  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
    layer?.opacity = 1.0
    layer?.cornerRadius = 5.0
    layer?.backgroundColor = NSColor.red.cgColor
  }
  
  // MARK: - Methods
  
  func animate(with error: APIClient.APIError, completion: @escaping () -> Void) {
    isHidden = false

    switch error {
    case .noImage:
      errorLabel.stringValue = "Looks like there's a video today...\nCheck again tomorrow for the updated APOD"
    default:
      errorLabel.stringValue = "Can't refresh image 😨"
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
      self.isHidden = true
      completion()
    }
  }
}
