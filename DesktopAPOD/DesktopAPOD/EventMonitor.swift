//
//  EventMonitor.swift
//  DesktopAPOD
//
//  Created by Richard Ash on 4/29/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import Cocoa

class EventMonitor {
  
  // MARK: - Private Properties
  
  private var monitor: Any?
  private let mask: NSEventMask
  private let handle: (NSEvent?) -> Void
  
  // MARK: - Initialization
  
  init(mask: NSEventMask, handle: @escaping (NSEvent?) -> Void) {
    self.mask = mask
    self.handle = handle
  }
  
  deinit {
    stop()
  }
  
  // MARK: - Methods
  
  func start() {
    monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handle)
  }
  
  func stop() {
    if let monitor = monitor {
      NSEvent.removeMonitor(monitor)
      self.monitor = nil
    }
  }
}
