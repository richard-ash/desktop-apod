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
  }
  
  func applicationWillTerminate(_ notification: Notification) {
    // Will terminate
  }

  // MARK: - Methods
  
  func showPopover(_ sender: Any?) {
    if let button = statusItem.button {
      popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
    }
  }
  
  func closePopover(_ sender: Any?) {
    popover.performClose(sender)
  }
  
  func togglePopover(_ sender: Any?) {
    popover.isShown ? closePopover(sender) : showPopover(sender)
  }

}

