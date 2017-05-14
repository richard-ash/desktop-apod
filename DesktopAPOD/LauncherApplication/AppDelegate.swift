//
//  AppDelegate.swift
//  LauncherApplication
//
//  Created by Richard Ash on 5/14/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let mainIdentifier = "com.richardwesleyash.DesktopAPOD"
    let runningApplications = NSWorkspace.shared().runningApplications
    let isMainRunning = runningApplications.contains { (application) -> Bool in
      application.bundleIdentifier == mainIdentifier
    }
    
    
    if !isMainRunning {
      DistributedNotificationCenter.default().addObserver(self, selector: #selector(terminate), name: NSNotification.Name("killLaunchApplication"), object: nil)
      
      let path = Bundle.main.bundlePath as NSString
      var components = path.pathComponents
      components.removeLast()
      components.removeLast()
      components.removeLast()
      components.append("MacOS")
      components.append("DesktopAPOD")
      
      let newPath = NSString.path(withComponents: components)
      NSWorkspace.shared().launchApplication(newPath)
    } else {
      terminate()
    }
  }
  
  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }
  
  func terminate() {
    NSApplication.shared().terminate(nil)
  }
  
  
}

