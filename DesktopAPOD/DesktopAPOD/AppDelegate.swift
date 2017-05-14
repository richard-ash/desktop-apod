//
//  AppDelegate.swift
//  DesktopAPOD
//
//  Created by Richard Ash on 4/29/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import Cocoa

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
    // Configure Status Item Button
    if let button = statusItem.button {
      button.image = #imageLiteral(resourceName: "JupiterStatusIcon")
      button.action = #selector(togglePopover)
    }
    
    // Configure the Popover View Controller
    if let popoverViewController = NSStoryboard.main.instantiateController(withIdentifier: PopoverViewController.identifier) as? PopoverViewController {
      popoverViewController.apiClient = apiClient
      popoverViewController.apodFileManager = apodFileManager
      popoverViewController.delegate = self
      popover.contentViewController = popoverViewController
    }
    
    // Configure the Event Monitor
    eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [unowned self] event in
      if self.popover.isShown {
        self.closePopover(event)
      }
    }
    eventMonitor?.start()
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
}

// MARK: - PopoverViewControllerDelegate

extension AppDelegate: PopoverViewControllerDelegate {
  func popoverViewController(_ popoverViewController: PopoverViewController, settingsWasTapped button: NSButton?) {
    settingsWindow = NSStoryboard.main.instantiateController(withIdentifier: "SettingsWindowController") as? NSWindowController
    settingsWindow?.showWindow(self)
    closePopover(button)
  }
}
