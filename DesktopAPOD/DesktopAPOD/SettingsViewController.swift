//
//  SettingsViewController.swift
//  DesktopAPOD
//
//  Created by Richard Ash on 5/13/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import Cocoa

class SettingsViewController: NSViewController {
  
  // MARK: - IBOutlet Properties
  
  @IBOutlet weak var textView: NSTextView!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.
    configureTextView()
  }
  
  // MARK: - IBAction Methods
  
  @IBAction func quit(_ sender: NSButton) {
    NSApplication.shared().terminate(sender)
  }
  
  // MARK: - Private Methods
  
  func configureTextView() {
    textView.backgroundColor = .clear
    textView.isEditable = false
    
    guard let licenseURL = Bundle.main.url(forResource: "License", withExtension: "txt") else { return }
    guard let licenseText = try? String(contentsOf: licenseURL, encoding: .utf8) else { return }
    
    textView.textStorage?.append(NSAttributedString(string: licenseText))
  }
  
}
