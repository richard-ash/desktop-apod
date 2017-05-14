//
//  SettingsViewController.swift
//  DesktopAPOD
//
//  Created by Richard Ash on 5/13/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import Cocoa

protocol SettingsViewControllerDelegate: class {
  func settingsViewController(_ controller: SettingsViewController, laucherToggledTo state: Bool)
}

class SettingsViewController: NSViewController {
  
  // MARK: - IBOutlet Properties
  
  @IBOutlet weak var textView: NSTextView!
  @IBOutlet weak var launcherButton: NSButton!
  
  // MARK: - Properties
  
  weak var delegate: SettingsViewControllerDelegate?

  // MARK: - Overridden Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTextView()
    configureLauncherButton()
  }
  
  // MARK: - IBAction Methods
  
  @IBAction func quit(_ sender: NSButton) {
    NSApplication.shared().terminate(sender)
  }
  
  @IBAction func toggleLauncherApplication(_ sender: NSButton) {
    switch sender.state {
    case NSOnState:
      UserDefaults.standard.set(true, forKey: "launcherApplication")
      delegate?.settingsViewController(self, laucherToggledTo: true)
    case NSOffState:
      UserDefaults.standard.set(false, forKey: "launcherApplication")
      delegate?.settingsViewController(self, laucherToggledTo: false)
    default:
      break
    }
  }
  
  // MARK: - Private Methods
  
  private func configureLauncherButton() {
    if UserDefaults.standard.bool(forKey: "launcherApplication") {
      launcherButton.state = NSOnState
    }
  }
  
  private func configureTextView() {
    textView.backgroundColor = .clear
    textView.isEditable = false
    
    guard let licenseURL = Bundle.main.url(forResource: "License", withExtension: "txt") else { return }
    guard let licenseText = try? String(contentsOf: licenseURL, encoding: .utf8) else { return }
    
    textView.textStorage?.append(NSAttributedString(string: licenseText))
  }
  
}
