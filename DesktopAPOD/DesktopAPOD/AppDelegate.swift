//
//  AppDelegate.swift
//  DesktopAPOD
//
//  Created by Richard Ash on 4/29/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  // MARK: - Properties
  
  let statusItem = NSStatusBar.system().statusItem(withLength: -2)
  let popover = NSPopover()
  let apodFileManager = APODFileManager()
  let apiClient = APIClient()
  var eventMonitor: EventMonitor?
  var settingsWindow: NSWindowController?
  
  // MARK: - NS Application Delegate

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Setup Launcher Application
    if UserDefaults.standard.bool(forKey: "launcherApplication") {
      setupLauncherApplication()
    }
    
    // Configure Status Item Button
    configureStatusBarButton()
    
    // Configure the Popover View Controller
    configurePopoverViewController()
    
    // Configure the Event Monitor
    configureEventMonitor()
  }
  
  // MARK: - Methods
  
  func showPopover(_ sender: Any?) {
    if let button = statusItem.button {
      popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
    }
    eventMonitor?.start()
  }
  
  func closePopover(_ sender: Any?) {
    popover.performClose(sender)
    eventMonitor?.stop()
  }
  
  func togglePopover(_ sender: Any?) {
    popover.isShown ? closePopover(sender) : showPopover(sender)
  }
  
  // MARK: - Private Methods
  
  fileprivate func setupLauncherApplication() {
    let launcherApplicationIdentifier = "com.richardash.LauncherApplication"
    
    SMLoginItemSetEnabled(launcherApplicationIdentifier as CFString, true)
    
    let startedAtLogin = NSWorkspace.shared().runningApplications.contains { (application) -> Bool in
      application.bundleIdentifier == launcherApplicationIdentifier
    }
    
    if startedAtLogin {
      DistributedNotificationCenter.default().post(name: NSNotification.Name("killLaunchApplication"), object: nil)
    }
  }
  
  private func configureStatusBarButton() {
    if let button = statusItem.button {
      button.image = #imageLiteral(resourceName: "JupiterStatusIcon")
      button.action = #selector(togglePopover)
    }
  }
  
  private func configureEventMonitor() {
    eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [unowned self] event in
      if self.popover.isShown {
        self.closePopover(event)
      }
    }
    eventMonitor?.start()
  }
  
  private func configurePopoverViewController() {
    if let popoverViewController = NSStoryboard.main.instantiateController(withIdentifier: PopoverViewController.identifier) as? PopoverViewController {
      popoverViewController.apiClient = apiClient
      popoverViewController.apodFileManager = apodFileManager
      popoverViewController.delegate = self
      popover.contentViewController = popoverViewController
    }
  }
}

// MARK: - PopoverViewControllerDelegate

extension AppDelegate: PopoverViewControllerDelegate {
  func popoverViewController(_ popoverViewController: PopoverViewController, settingsWasTapped button: NSButton?) {
    settingsWindow = NSStoryboard.main.instantiateController(withIdentifier: "SettingsWindowController") as? NSWindowController
    
    let settingsViewController = settingsWindow?.contentViewController as? SettingsViewController
    settingsViewController?.delegate = self
    
    settingsWindow?.showWindow(self)
    closePopover(button)
  }
}

// MARK: - SettingsViewControllerDelegate

extension AppDelegate: SettingsViewControllerDelegate {
  func settingsViewController(_ controller: SettingsViewController, laucherToggledTo state: Bool) {
    if state {
      setupLauncherApplication()
    } else {
      let launcherApplicationIdentifier = "com.richardash.LauncherApplication"
      SMLoginItemSetEnabled(launcherApplicationIdentifier as CFString, false)
      DistributedNotificationCenter.default().post(name: NSNotification.Name("killLaunchApplication"), object: nil)
    }
  }
}
