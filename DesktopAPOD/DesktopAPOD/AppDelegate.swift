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
  
  // MARK: - NS Application Delegate

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Configure Status Item Button
    if let button = statusItem.button {
      button.image = #imageLiteral(resourceName: "StatusBarButtonImage")
      button.action = #selector(AppDelegate.togglePopover)
    }
    
    // Configure the Popover View Controller
    let storyboard = NSStoryboard(name: "Main", bundle: nil)
    if let popoverViewController = storyboard.instantiateController(withIdentifier: PopoverViewController.identifier) as? PopoverViewController {
      popoverViewController.apiClient = apiClient
      popoverViewController.apodFileManager = apodFileManager
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
  
  func applicationWillTerminate(_ notification: Notification) {
    // Will terminate
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

